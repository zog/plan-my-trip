define [
  'models/base'
  'models/stores'
  'leaflet'
  'backbone'
  'require'
], (BaseModel, Stores, L)->
  'use strict';

  POI = BaseModel.extend
    localStorage: Stores.Pois
    allCategories: [
      "food"
      "culture"
      "sightseing"
      "other"
    ]

    allCategoriesColors: {
      food: 'red'
      culture: 'green'
      sightseing: 'blue'
      other: 'black'
    }

    allCategoriesIcons: {
      food: 'icon-red'
      culture: 'icon-green'
      sightseing: 'icon-blue'
      other: 'icon-black'
    }

    initialize: () ->

    defaults: {
      description: ""
      category: ""
      visited: false
    }

    color: ->
      @allCategoriesColors[@attributes.category]

    markerIcon: ->
      icon = @allCategoriesIcons[@attributes.category]
      L.icon
        iconUrl: '/images/' + icon + '.png',
        iconRetinaUrl: '/images/' + icon + '@2x.png',
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        # popupAnchor: [-3, -76],
        shadowUrl: '/bower_components/leaflet/dist/images/marker-shadow.png',
        shadowRetinaUrl: '/bower_components/leaflet/dist/images/marker-shadow@2x.png',
        # shadowSize: [68, 95],
        # shadowAnchor: [22, 94]

    available_categories: ->
      @allCategories

    validate: (attrs, options) ->
      errors = []
      errors.push "Name is mandatory" unless attrs.name?.length > 0
      return errors if errors.length > 0

    parse: (response, options) ->
      response
