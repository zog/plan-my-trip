define [
  'models/cachebtncontrol'
  'views/base',
  'models/settings'
  'offlinemap/offlinelayer',
  'jquery',
  'backbone',
  'leaflet',
], (CacheBtnControl, BaseView, Settings, OfflineLayer)->
  'use strict';

  MapView = BaseView.extend

    className: ''

    events: {
    }

    initialize: () ->

    setBounds: (newBounds)->
      # console.log "setBounds", newBounds
      @bounds = newBounds

    resetCenter: ->
      # console.log "resetCenter"
      @bounds = null
      @center()

    centerOnArea: (area)->
      data = area.attributes
      if data?.minLat?
        @setBounds [[data.minLat, data.minLng], [data.maxLat, data.maxLng]]
        @center()
      if area.getBounds?
        @setBounds area.getBounds()
        @center()

    center: ()->
      # console.log "center"
      Settings.load().then (settings)=>
        # console.log "@bounds?", @bounds?, @bounds
        unless @bounds?
          data = settings.attributes
          if data.minLat?
            @bounds = [[data.minLat, data.minLng], [data.maxLat, data.maxLng]]
        @map.fitBounds @bounds

    accessToken: ->
      'pk.eyJ1Ijoiem9nem9nIiwiYSI6IjNlNTcwOTFiY2Q1NmQwYzk3ODhiN2JhY2Q1NjgwZWY1In0.zkd4hgnD3WzMc0hwWET6Ag'

    tileLayerUrl: ->
      'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}'

    transportLayerUrl: ->
      'https://c.tile.thunderforest.com/transport/{z}/{x}/{y}.png'

    mapOptions: ->
      {
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>'
        maxZoom: 18
        id: 'zogzog.526839fc'
        accessToken: @accessToken()
      }

    offlineLayer: (onReady, onError)->
      options = @mapOptions()

      options.onReady = onReady
      options.onError = onError
      options.storeName = "planMyTrip"
      options.dbOption = "WebSQL"
      options.minZoomLevel = @map.getZoom()
      # new OfflineLayer( @tileLayerUrl(), options)
      new OfflineLayer( @transportLayerUrl(), options)

    render: () ->
      @map = L.map('map').setView([51.505, -0.09], 13)

      options = @mapOptions()
      # L.tileLayer @tileLayerUrl(), @mapOptions()
      # .addTo @map

      L.tileLayer @transportLayerUrl(), @mapOptions()
      .addTo @map

      aMap = @map

      onReady = () =>
        offlineLayer.addTo aMap
        @center()

      onError = (errorType, errorData1, errorData2) ->
        console.log(errorType)
        console.log(errorData1)
        console.log(errorData2)

      offlineLayer = @offlineLayer onReady, onError

