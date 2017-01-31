define [
  'models/base'
  'models/stores'
  'models/poi'
  'collections/pois'
  'backbone'
  'require'
], (BaseModel, Stores, POI)->
  'use strict';

  Area = BaseModel.extend
    localStorage: Stores.Areas
    initialize: () ->

    defaults: {
      name: ''
      description: ''
      color: '#FF0000'
      pois: []
    }

    bounds: ->
      [[@attributes.minLat, @attributes.minLng], [@attributes.maxLat, @attributes.maxLng]]

    pois: ->
      @_pois = new POI.Collection()
      for id in @attributes.pois
        console.log "id", id
        p = new POI(id: id).fetch
          success: (o)=>
            @_pois.add o
      console.log "pois", @_pois
      @_pois

    addPoi: (poi)->
      @attributes.pois.push poi.id

    validate: (attrs, options) ->
      errors = []
      errors.push "Name is mandatory" unless attrs.name?.length > 0
      return errors if errors.length > 0

    parse: (response, options) ->
      response
