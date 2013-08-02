# a 'global' vent module that doesn't explicitly depend on your application and can be depended on anywhere.
#
# Usage:
# define ["vent"], (vent) ->
#   vent.on "eventName", ->
#     vent.trigger "eventName"
#

define ['jquery-adapter', 'underscore', 'backbone', 'marionette'], ($, _, Backbone, Marionette) ->

  return new Backbone.Wreqr.EventAggregator()
