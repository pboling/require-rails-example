define [
  'ba-debug',
  'marionette'
], (console, Marionette) ->
  class ApplicationController extends Marionette.Controller
    layout: ->
      App = require('app')
      App.layout

    root: ->
      @layout().showRoot()
