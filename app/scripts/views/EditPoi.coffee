define [
  'views/newpoi'
  'models/area'
  'models/poi'
], (NewPoiView, Area, POI) ->

  'use strict';

  EditPoiView = NewPoiView.extend

    template: JST['PoiForm']

    tagName: 'div'

    className: ''

    events: {
      "submit form": "validate"
    }

    initialize: (@area, @model) ->
      console.log "@model", @model
      @listenTo @model, 'change', @render
      @listenTo @model, 'invalid', @render
      @submit = @$el.find("input[type=submit]")

    showMap: (data) ->
      return if @map?
      @mapView = window.planMyTrip.map
      @map = @mapView.map
      @mapView.centerOnArea @area

    customRender: (data) ->
      @showMap data, false
      @mapBounds = @area.bounds()
      @drawMapItem @model.attributes.mapItem, false
      @initTools()

    redirect: ->
      "#areas/" + @area.id

    afterSave: ->

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

      for k,l of @layer._layers
        @drawnItems.addLayer l

      @map.on 'draw:created', (e) =>
        layer = e.layer
        @drawnItems.addLayer layer
