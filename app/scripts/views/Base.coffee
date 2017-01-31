define [
  'models/settings'
  'backbone'
  'templates'
], (Settings)->
  'use strict';

  BaseView = Backbone.View.extend

    tagName: 'div'

    className: ''

    events: {
      "submit form": "validate"
    }

    customRender: (data)->
    customData: (data)->
      data

    render: ->
      $('#main .back').click =>
        document.location = @backUrl()
      @mapView = window.planMyTrip.map
      @map = @mapView.map

      @subviews = [] unless @subviews?
      data = @model?.toJSON()
      data = @collection?.toJSON() unless data?
      data = {} unless data?
      data["validationError"] = @model?.validationError
      if @flash
        data["flash"] = @flash
        @flash = null

      data = @customData(data)
      @$el.html @template(data)
      $('#main').append @$el
      @hideErrors()
      @showErrors() if data["validationError"]?
      @customRender(data)

    moreClean: ->

    backUrl: ->
      '#'

    clean: ->
      @moreClean()
      @edit?.disable()
      @rect?.disable()
      if @layer
        @map.removeLayer @layer
      if @subviews?
        for v in @subviews
          v.clean()

    redirect: (action="edit")->
      "#"

    beforeValidate: ->
      console.log "beforeValidate"
      true

    afterSave: ->

    validate: (e)->
      @hideErrors()
      vals = @values()
      e.preventDefault()
      @model.set vals
      if @beforeValidate()
        @model.save(
          vals
          success: =>
            console.log "success"
            @afterSave()
            document.location = @redirect()
        )

      false

    values: ->
      out = {}
      for input in @$el.find("input[type!=submit], select, textarea")
        out[$(input).attr('name')] = $(input).val()

      if @layer?
        bounds = @layer.getLatLngs()
        out.minLat = bounds[0].lat
        out.minLng = bounds[0].lng
        out.maxLat = bounds[2].lat
        out.maxLng = bounds[2].lng
      else if @rect?
        bounds = @rect.getLatLngs()

      if bounds
        out.minLat = bounds[0].lat
        out.minLng = bounds[0].lng
        out.maxLat = bounds[2].lat
        out.maxLng = bounds[2].lng
      out

    addLayer: (e)->
      @layer = e.layer
      @map.addLayer(@layer)
      @edit = new L.Edit.Rectangle @layer
      @edit.enable()

    rectOptions: ->
      {
        color: "#ff7800"
        weight: 1
      }

    mapItemOptions: ->
      style:
        color: "#000"
        weight: 1


    showError: (msg) ->
      $(".errors").html msg
      @showErrors()

    showErrors: (msg) ->
      $(".errors").show()

    hideErrors: ->
      $(".errors").hide()

    centerIfNeeded: (center, bounds)->
      # console.log "centerIfNeeded", center, !@mapBounds?, bounds
      if center
        @mapView.setBounds(bounds) if !@mapBounds?
        @mapView.center()

    drawMapItem: (data, addToMap=true)->
      @layer = L.geoJson data, @mapItemOptions()
      @layer.addTo(@map) if addToMap

    showMap: (data, editable=true, center=true) ->
      return if @mapShown?
      @mapView = window.planMyTrip.map
      @map = @mapView.map

      @mapShown = true
      if @mapBounds?
        @mapView.setBounds @mapBounds
      if data?.minLat?
        bounds = [[data.minLat, data.minLng], [data.maxLat, data.maxLng]]
        @layer = L.rectangle(bounds, @rectOptions())
        @layer.addTo(@map)
        if editable
          @edit = new L.Edit.Rectangle @layer
          @edit.enable()
        @centerIfNeeded center, bounds

      else if data?.mapItem?
        @drawMapItem data.mapItem
      else
        Settings.load().then (settings)=>
          data = settings.attributes
          if data.minLat?
            bounds = [[data.minLat, data.minLng], [data.maxLat, data.maxLng]]
            @centerIfNeeded center, bounds

          @rect = new L.Draw.Rectangle(@map, {})
          @rect.enable()
          @map.on 'draw:created', (e) =>
            @addLayer(e)

