# the 'jquery-adapter', loaded below, is a require-js shim which includes jquery, and jquery_ujs
define [
  'ba-debug',
  # Libraries
  'jquery-adapter', 'underscore', 'backbone', 'marionette', 'utils'
], (console, $, _, Backbone, Marionette, utils) ->

  console.log('Loaded Example App')

  class SimpleApp extends Marionette.Application

    navigate: (fragment, options = {}) ->
      # default trigger option to true
      options.trigger = true if (typeof options.trigger == "undefined")
      Backbone.history.navigate(fragment, options)

  # Creates a new application from above class
  App = new SimpleApp()

  # returns app instance so the rest of the app can refrence it globally
  # by requiring it
  App
