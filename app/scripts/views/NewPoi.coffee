define [
  'views/base'
  'models/area'
  'models/poi'
], (BaseView, Area, POI) ->

  'use strict';

  NewPoiView = BaseView.extend

    template: JST['PoiForm']

    tagName: 'div'

    className: ''

    events: {
      "submit form": "validate"
    }

    initialize: (@area) ->
      @model = new POI()

      @listenTo @model, 'change', @render
      @listenTo @model, 'invalid', @render
      @submit = @$el.find("input[type=submit]")

    showMap: (data) ->
      return if @map?
      @mapView = window.planMyTrip.map
      @map = @mapView.map
      @mapView.centerOnArea @area

    customData: (data) ->
      data.available_categories = @model.available_categories()
      data

    customRender: (data) ->
      @showMap data, false
      @initTools()
      @mapBounds = @area.bounds()

    redirect: ->
      "#areas/" + @area.id

    afterSave: ->
      @area.addPoi @model
      @area.save()

    initTools: ()->
      return if @drawControl?
      @drawnItems = new L.FeatureGroup()
      @map.addLayer @drawnItems

      @drawControl = new L.Control.Draw
        edit:
          featureGroup: @drawnItems
        draw:
          circle: false

      @map.addControl @drawControl
      @map.on 'draw:created', (e) =>
        type = e.layerType
        layer = e.layer
        @drawnItems.addLayer layer


    clean: ->
      @map.removeControl @drawControl
      @map.removeLayer @drawnItems

    values: ->
      out = {}
      for input in @$el.find("input[type!=submit], select, textarea")
        out[$(input).attr('name')] = $(input).val()

      if @drawnItems?
        out["mapItem"] = @drawnItems.toGeoJSON()

      out
