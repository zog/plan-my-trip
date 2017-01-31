define [
  'views/base'
  'models/area'
  'views/offlineprogresscontrol'
  'leaflet'
  'vendor/leaflet.draw'
], (BaseView, Area, OfflineProgressControl) ->

  'use strict';

  EditAreaView = BaseView.extend

    template: JST['AreaForm']

    initialize: () ->
      @listenTo @model, 'change', @render
      @listenTo @model, 'invalid', @render
      @submit = @$el.find("input[type=submit]")

    customRender: (data) ->
      @showMap data
      @colorField = @$el.find("[name*=color]")
      @colorField.on 'change', =>
        val = @colorField.val()
        @layer.setStyle @rectOptions val
      data

    redirect: ->
      "#areas/" + @model.id

    rectOptions: (color)->
      color = @model.attributes.color unless color?
      {
        fill: true
        weight: 1
        color: @model.attributes.color
        fillColor: color
      }

    offlineLayer: ->
      offlineLayer = @mapView.offlineLayer =>
        @onReady()
      , (err, msg)=>
        @onError(err, msg)

    onReady: ->
      console.log 'ready'
      @_offlineLayer.addTo(@map)
      nbTiles = @_offlineLayer.calculateNbTiles @map.getZoom() + 3
      if nbTiles == -1
        return
      if(nbTiles < 10000)
        console.log("Will be saving: " + nbTiles + " tiles");

      progressControls = new OfflineProgressControl()
      progressControls.setOfflineLayer(@_offlineLayer)
      progressControls.render()

      @_offlineLayer.saveTiles @map.getZoom() + 3, @onStarted, @onSuccess, @onError

    onStarted: ->
      console.log 'started'

    onSuccess: ->
      console.log 'success'

    onError: (e, msg)->
      console.log 'error: ', e, msg

    beforeValidate: ->
      console.log "beforeValidate"
      data = @values()
      @model.set data
      console.log @model.changed
      bounds = [[data.minLat, data.minLng], [data.maxLat, data.maxLng]]
      @mapView.setBounds bounds
      @mapView.center()
      if @model.changed.minLat? || @model.changed.maxLat || @model.changed.minLng? || @model.changed.maxLng?
        @_offlineLayer = @offlineLayer()

      true




