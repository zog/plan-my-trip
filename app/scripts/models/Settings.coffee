define [
  'models/base'
  'models/stores'
  'backbone'
  'require'
], (BaseModel, Stores)->
  'use strict';

  Settings = BaseModel.extend
    localStorage: Stores.Settings
    initialize: () ->

    defaults: {}

    validate: (attrs, options) ->
      errors = []
      errors.push "Name is mandatory" unless attrs.name?.length > 0
      return errors if errors.length > 0

    parse: (response, options) ->
      response

  Settings.load = ->
    $.Deferred (d)->
      s = new Settings
      s.fetch()
      .done (res) ->
        d.resolve new Settings res[0]
      .fail ->
        d.resolve new Settings()

  Settings
