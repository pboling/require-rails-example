define [
  # Libraries
  'jquery-adapter', 'underscore', 'backbone', 'marionette', 'handlebars'

  # Templae
  'templates/layout',

  # Views
  'views/welcome'

], ($, _, Backbone, Marionette, Handlebars, layoutTemplate, WelcomeView) ->

  class AppLayout extends Marionette.Layout

    el: '#layout_wrapper'

    template: if ($.environment.config('env_name') == 'development' && !$.environment.config('foggy'))
      layoutTemplate
    else
      window.HandlebarsTemplates.layout

    regions:
      content: '#region-content'

    showRoot: ->
      view = new WelcomeView()
      console.log('Showing Root')
      @content.show(view)
