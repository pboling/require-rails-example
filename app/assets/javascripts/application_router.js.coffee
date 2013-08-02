define [
  'marionette'
], (Marionette) ->
  class ApplicationRouter extends Marionette.AppRouter
    appRoutes:
      '': 'root'
