
define [
    'jquery',
    'underscore',
    'backbone',
    'routes/app',
    'views/map',
],  ($, _, Backbone, AppRouter, MapView) ->
  'use strict'

  PlanMyTrip = class
    constructor: ->
      @map = new MapView

    render: =>
      @map.render()
      new AppRouter
      Backbone.history.start()
      $('.header a.visit').click (e)=>
        e.preventDefault()
        window.location = '/visit.html'
        false

    decorateUrl: (base)=>
      '#' + base

  PlanMyTrip
