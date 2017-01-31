define [
  'views/base'
  'models/settings'
  'models/stores'
  'models/poi'
  'models/area'
], (BaseView, Settings, Stores, POI, Area)->
  'use strict';

  SettingsView = BaseView.extend

    template: JST['Settings']
    events: {
      'click .export': 'export'
      'click .import': 'import'
    }
    initialize: ()->
      Settings.load().then (settings)=>
        @model = settings

    customRender: (data) ->
      @showMap data, true

    clean: ->
      @map.removeLayer(@layer)

    import: ->
      input = $('[name=import]').val()

      alert("start")
      data = Stores.Pois.serializer.deserialize input
      alert("parsed")
      Stores.Pois._clear()
      Stores.Settings._clear()
      Stores.Areas._clear()
      for poi in data.pois
        Stores.Pois.update new POI(poi)
      for area in data.areas
        Stores.Areas.update new Area(area)
      for setting in data.settings
        Stores.Settings.update new Settings(setting)
      alert("done")

    export: ->
      pois = Stores.Pois.findAll()
      areas = Stores.Areas.findAll()
      settings = Stores.Settings.findAll()
      serializer = Stores.Pois.serializer.serialize
      out = serializer  {
        pois
        areas
        settings
      }
      txt = $('<textarea/>')
      txt.html out
      $('#status').append txt

      console.log out


