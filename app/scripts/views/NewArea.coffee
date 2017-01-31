define [
  'views/base'
  'models/area'
  'leaflet'
  'vendor/leaflet.draw'
], (BaseView, Area) ->

  'use strict';

  NewAreaView = BaseView.extend

    template: JST['AreaForm']

    initialize: () ->
      @model = new Area

      @listenTo @model, 'change', @render
      @listenTo @model, 'invalid', @render
      @submit = @$el.find("input[type=submit]")

    customRender: (data) ->
      @showMap data
      data

    redirect: ->
      "#areas/" + @model.id


