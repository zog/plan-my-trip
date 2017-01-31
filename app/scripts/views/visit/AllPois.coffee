define [
  'views/base'
  'collections/pois'
  'views/visit/poi'
  'models/poi'
], (BaseView, Pois, PoiView, Poi)->
  'use strict';

  AllPoisView = BaseView.extend

    template: JST['visit/AllPois']

    tagName: 'div'

    className: ''

    events: {}

    initialize: () ->
      @subviews = []
      @listenTo @collection, 'add', @addOne
      @listenTo @collection, 'reset', @addAll

    customRender: () ->
      @list = @$el.find("#pois")
      @addAll()
      @initFilters()

    addAll: ()->
      @collection.each @addOne, this

    customData: (data) ->
      data.available_categories = (new Poi).available_categories()
      data

    addOne: (poi)->
      return unless @list?
      view = new PoiView model: poi
      view.area = @area
      view.render()
      @list.append view.$el
      @subviews.push view
      @listenTo view.model, 'change', @filterSubviews

    filterSubviews: ->
      for v in @subviews
        show = true
        for attr, val of @filtersValues
          show = show && v.model.attributes[attr] == val

        if show
          v.show()
        else
          v.hide()

    initFilters: ->
      @filtersValues = {}
      @items = @$el.find('tr.poi')
      @filters = @$el.find('.filters')
      @filters.each (_, filtersGroup)=>
        attribute = $(filtersGroup).data 'attribute'
        $(filtersGroup).find(".filter").click (e)=>
          filter = $(e.target)
          $(filtersGroup).find(".filter").removeClass 'active'
          filter.addClass 'active'
          val = filter.data('filter')
          if val?
            @filtersValues[attribute] = val
          else
            delete @filtersValues[attribute]

          @filterSubviews()



