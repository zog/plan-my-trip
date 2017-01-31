define [
  'views/base'
  'models/poi'
], (BaseView, POI) ->
  'use strict';

  PoiView = BaseView.extend

    template: JST['Poi']

    tagName: 'div'

    className: 'poi row'

    events: {
      "click .delete": "delete"
      "click .edit": "editPoi"
      "click .mark-visited": "markVisited"
      "click .mark-non-visited": "markNonVisited"
      # "mouseover": "highlight"
      "mousedown .name": "highlight"
      # "mouseout": "downlight"
      "mouseup .name": "downlight"
    }

    initialize: () ->
      @listenTo @model, 'change', @render

    markVisited: () ->
      @model.save(
        visited: true
      )

    markNonVisited: () ->
      @model.save(
        visited: false
      )

    highlight: ->
      @description.show()
      @layer.setStyle @mapItemOptions(1).style
      for k, layer of @layer._layers
        layer.setOpacity? 1

    downlight: ->
      @description.hide()
      @layer.setStyle @mapItemOptions().style
      for k, layer of @layer._layers
        layer.setOpacity? 0.2

    render: () ->
      data = @model.toJSON()
      @$el.html @template(data)
      @$el.addClass @model.attributes.category
      @showMap data, false
      @description = @$el.find(".description")
      @downlight()
      @shown = true
      console.log @layer
      for _, l of @layer._layers
        l.on "mousedown", =>
          @highlight()

      @map.on "mouseup", =>
        @downlight()

    mapItemOptions: (opacity=0.2)->
      style:
        color: @model.color()
        weight: 5
        fillOpacity: opacity

      pointToLayer: (featureData, latlng)=>
        L.marker latlng, {
          icon: @model.markerIcon()
          opacity: opacity
        }

    delete: ()->
      @model.destroy()
      @$el.remove()
      @clean()

    show: ()->
      return if @shown
      @shown = true
      @map.addLayer @layer
      @$el.show()

    hide: ()->
      return unless @shown
      @shown = false
      @map.removeLayer @layer
      @$el.hide()

    editPoi: ()->
      document.location = '#areas/' + @area.id + "/pois/" + @model.id + '/edit'
