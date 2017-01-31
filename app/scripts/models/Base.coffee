define [
  'backbone'
  'templates'
], (BaseModel)->
  'use strict';

  BaseModel = Backbone.Model.extend

    initialize: () ->

    defaults: {}

    validate: (attrs, options) ->

    parse: (response, options) ->
      response
