define [
  'views/poi'
  'models/poi'
], (BaseView, POI) ->
  'use strict';

  PoiView = BaseView.extend

    template: JST['visit/Poi']

    tagName: 'li'

    className: 'poi'

    events: {
      "click .delete": "delete"
      "click .edit": "editPoi"
      "click .name": "toggle"

    }

    initialize: () ->
      @listenTo @model, 'change', @render

    showOnMap: () ->
      @downlight()
      @mapView.centerOnArea @layer
      window.planMyTrip.hideDrawer()

    markVisited: () ->
      @model.save(
        {
          visited: true
        }
        success: =>
          @highlight()
      )

    markNonVisited: () ->
      @model.save(
        {
          visited: false
        }
        success: =>
          @highlight()
      )

    toggle: ->
      if @$el.hasClass 'highlighted'
        @downlight()
      else
        @highlight()

    highlight: ->
      @details.show()
      @$el.addClass 'highlighted'
      @layer.setStyle @mapItemOptions(1).style
      for k, layer of @layer._layers
        layer.setOpacity? 1

    downlight: ->
      @details.hide()
      @$el.removeClass 'highlighted'
      @layer.setStyle @mapItemOptions().style
      for k, layer of @layer._layers
        layer.setOpacity? 0.2

    initDetails: ->
      @details.remove() if @details?
      @details = @$el.find(".details")
      $("#more").append @details
      @.details.find(".mark-visited").click =>
        @markVisited()
      @.details.find(".mark-non-visited").click =>
        @markNonVisited()
      @.details.find(".close").click =>
        @downlight()
      @.details.find(".show-on-map").click =>
        @showOnMap()
      @downlight()

    render: () ->
      data = @model.toJSON()
      data.color = @model.color()
      @$el.html @template(data)
      @$el.addClass @model.attributes.category
      @showMap data, false
      @initDetails()
      @shown = true
      for _, l of @layer._layers
        l.on "click", =>
          @highlight()

    show: ()->
      return if @shown
      @shown = true
      @map.addLayer @layer
      @$el.find(".name").show()

    hide: ()->
      return unless @shown
      @shown = false
      @map.removeLayer @layer
      @$el.find(".name").hide()


