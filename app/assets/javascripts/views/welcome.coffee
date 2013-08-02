define [
  'ba-debug',
  'marionette',
  'templates/welcome',
], (console, Marionette, templateView) ->
  class WelcomeView extends Marionette.ItemView

    template: if ($.environment.config('env_name') == 'development' && !$.environment.config('foggy'))
      templateView
    else
      window.HandlebarsTemplates.welcome
