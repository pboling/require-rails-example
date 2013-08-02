/*!
 * jQuery Environment Plugin
 *
 * Allows the setting of environment specific configuration.
 * The jQuery equivalent of Rails' config/environments files.
 *
 * NOTE:  Do not use this plugin to store 'secret' data about your app, or you will be exposing it to your DOM,
 *        and thereby hackety-hackers.
 *
 * Use without DOM (globally):
 *
 *  Option 1.
 *
 *      Example:
 *
 *          // Setup in a conditionally loaded script
 *          $.environment({ here: 'dragon', env_name: 'production', foo: 'bar'});
 *
 *          // Usage elsewhere
 *          $.environment.config('here');       // dragon
 *          $.environment.config('env_name');   // production
 *          $.environment.config('foo');        // bar
 *
 * Two (three!) ways to use with DOM:
 *
 *  Option 1. via the data-environment attribute on any HTML element.
 *
 *      Example:
 *
 *          <body data-environment-configuration="{foo: 'bar'}">)
 *
 *  Option 2. via the instantiation options for the plugin.
 *
 *      Example:
 *
 *          $('body').environment({ here: 'dragon', env_name: 'production' });
 *
 *  Option 3. Option 1 + Option 2
 *
 *      Example:
 *
 *          // Do both of the above examples and then you get this usage:
 *          $('body').environment.config('foo');      // bar
 *          $('body').environment.config('here');     // dragon
 *          $('body').environment.config('env_name'); // production
 *
 * Author: @pboling
 * Version: 1.0
 * Release Date: September 21, 2012
 * Based on:  'Highly configurable' mutable plugin boilerplate by @markdalgleish and @addyosmani,
 *            see http://coding.smashingmagazine.com/2011/10/11/essential-jquery-plugin-patterns/
 * Licensed under the MIT license
 * Note that with this pattern, as per Alex Sexton's, the plugin logic
 * hasn't been nested in a jQuery plugin. Instead, we just use
 * jQuery for its instantiation.
 * the semi-colon before the function invocation is a safety
 * net against concatenated scripts and/or other plugins
 * that are not closed properly.
 */
;(function( $, window, document, undefined ){
//  console.log('loaded jquery-environment');

  // Create the defaults once
  var pluginName = 'environment',
    pluginOptions = {
      env_name: 'override me' // The name of the current environment (e.g. staging, production, development)
    };

  function is(type, obj) {
    var classy = Object.prototype.toString.call(obj).slice(8, -1);
    return obj !== undefined && obj !== null && classy === type;
  }

  // Environment plugin constructor
  var Environment = function ( options, elem ) {
//    console.log('[jquery-environment] constructor options:',options, elem);
    this.elem = elem;
    this.$elem = $(elem);
    this.options = options;

    // Support customization of the plugin based on an HTM5 data attribute. Usage example:
    //  <div id='thing' data-environment-configuration='{"message":"Goodbye World!"}'></div>
    if (this.$elem) {
      this.metadata = this.$elem.data( 'environment-configuration' ) || {};
//      console.log('this.metadata from elem',this.metadata);
    } else {
      this.metadata = {};
//      console.log('this.metadata',this.metadata);
    }

    if (options && options.hasOwnProperty('callback')) {
      this.callback = options.callback;
    }

    this.options = options;

  };

  // the plugin prototype
  Environment.prototype = {
    defaults: pluginOptions,

    init: function () {
//      console.log('[jquery-environment] init defaults:',this.defaults);
//      console.log('[jquery-environment] init options:',this.options);
//      console.log('[jquery-environment] init metadata:',this.metadata);
      // Introduce defaults that can be extended either
      // globally or using an object literal.
      this.config = $.extend({}, this.defaults, this.options, this.metadata);
//      console.log('[jquery-environment] init config:',this.config);

      // Sample usage:
      // Set the message per instance:
      // $('#elem').environment({ env_name: 'production'});
      // or
      // var env = new Environment({ env_name: 'staging'}).init()
      // or use without DOM interaction:
      // var env = new Environment({ env_name: 'staging'}).init()
      // or, set the global default properties:
      // Environment.defaults.env_name = 'production'

      if (this.callback && this.callback.isFunction()) {
        this.callback();
      }
      return this;
    }
  }

  var selector_tag = '[jquery-environment-selector]',
    global_tag = '[jquery-environment-global]';
  var methods = {
    init : function( options ) {
//      console.log(selector_tag,'DOM-having options',options);
      if (options !== undefined) {
        //nothing
      } else {
        options = {};
      }

      if (Environment.configured_elements !== undefined) {
//        console.log(selector_tag, Environment.configured_elements.length, 'pre-existing element configurations');
      } else {
        Environment.configured_elements = {};
      }

//      console.log('this',$(this));
      return this.each(function() {
        Environment.configured_elements[$(this).selector] = new Environment( options, this ).init();
//        console.log(selector_tag,'configured_elements',Environment.configured_elements);
      });
    },
    set : function( key, value ) {
//      console.log('set',key,'to',value);
      var result = [];
      this.each(function() {
//        console.log(selector_tag,'setting:', Environment.configured_elements[$(this).selector]);
        if (Environment.configured_elements[$(this).selector] !== undefined) {
          Environment.configured_elements[$(this).selector].config[key] = value;
        } else {
//          console.log(selector_tag,'set: not configured');
        }
      });
      return result;
    },
    get : function( key ) {
//      console.log(selector_tag,'get',key);
      var result = [];
      this.each(function() {
        if (Environment.configured_elements[$(this).selector] !== undefined) {
          result.push(Environment.configured_elements[$(this).selector].config[key]);
        } else {
//          console.log(selector_tag,'get: not configured');
        }
      });
      return result;
    },
    all : function () {
//      console.log('all');
      var result = [];
      this.each(function() {
//        console.log(selector_tag,'getting configuration for',$(this).selector);
        if (Environment.configured_elements[$(this).selector] !== undefined) {
          result.push(Environment.configured.config);
        } else {
//          console.log(selector_tag,'all: not configured');
        }
      });
      return result;
    }
  };

  $.fn[pluginName] = function( method ) {
    // Method calling logic
    if ( methods[method] ) {
      return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else {
      return methods.init.apply( this, arguments );
    }
  };

  $[pluginName] = function (options) {
//    console.log(global_tag,'DOM-free options',options);
    Environment.configured = new Environment( options ).init();
    return Environment.configured.config;
  }

  $[pluginName].config = function (key, value) {
    if (Environment.configured !== undefined) {
//      console.log(global_tag,'configured:', Environment.configured);
    } else {
//      console.log(global_tag,'not configured');
      return undefined;
    }
    if (value !== undefined) {
//      console.log(global_tag,'set',key,'to',value);
      Environment.configured.config[key] = value;
    } else if (key !== undefined) {
//      console.log(global_tag,'get',key);
      return Environment.configured.config[key];
    } else {
//      console.log(global_tag,'hot dog',Environment.configured.config);
      return Environment.configured.config;
    }
  }

})( jQuery, window , document );
