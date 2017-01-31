
define [
    'jquery',
    'underscore',
    'backbone',
    'routes/visit',
    'views/map',
],  ($, _, Backbone, VisitRouter, MapView) ->
  'use strict'

  PlanMyTrip = class
    constructor: ->
      @map = new MapView

    render: =>
      @map.render()
      @$main = $('#main')
      new VisitRouter
      Backbone.history.start()
      $('html').addClass 'visit'
      @hideDrawer()

      $('#main .tab').click =>
        @toggleDrawer()


    toggleDrawer: ->
      console.log "toggleDrawer"
      if @mainVisible
        @hideDrawer()
      else
        @showDrawer()

    hideDrawer: ->
      @$main.addClass 'hidden'
      @mainVisible = false

    showDrawer: ->
      @$main.removeClass 'hidden'
      @mainVisible = true

    decorateUrl: (base)=>
      '#' + base

    setTabTitle: (title)=>
      $('#main .tab').html title

  PlanMyTrip
