define [
  'views/base',
  'collections/areas'
  'views/area'
  'jquery',
  'backbone',
], (BaseView, AreasCollection, AreaView)->
  'use strict';

  AllAreasView = BaseView.extend

    template: JST['AllAreas']

    tagName: 'div'

    events: {
    }

    initialize: () ->
      @subviews = []
      @collection = new AreasCollection
      @listenTo @collection, 'add', @addOne
      @listenTo @collection, 'reset', @addAll
      @collection.fetch()

    centerOnArea: (area)->
      @map.centerOnArea area

    render: () ->
      @map = window.planMyTrip.map
      @$el.html @template(@collection.toJSON())
      $('#main').append @$el
      @list = @$el.find("#areas")
      @addAll()
      # @$el.on 'mouseout', (e)=>
      #   unless $.contains( @$el[0], e.toElement)
      #     @map.resetCenter()

    addAll: ()->
      @collection.each @addOne, this

    addOne: (area)->

      return unless @list?
      view = new AreaView model: area
      view.render()
      @subviews.push view
      @list.append view.el
      $(view.el).find('.preview').on 'click', (e)=>
        e.preventDefault()
        @centerOnArea area

