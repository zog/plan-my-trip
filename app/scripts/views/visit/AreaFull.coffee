define [
  'views/base'
  'views/visit/allpois'
], (BaseView, AllPoisView)->
  'use strict';

  AreaFullView = BaseView.extend

    template: JST['AreaFull']

    className: ''

    events: {
      "click .delete.area": "delete"
      "click .edit.area": "editArea"
    }

    initialize: () ->
      @subviews = []
      @listenTo @model, 'change', @render

    customRender: (data) ->
      @showMap data, false
      v = new AllPoisView(collection: @model.pois())
      v.area = @model
      v.render()
      @subviews.push v
      @$el.find(".pois").append v.$el
      window.planMyTrip.setTabTitle "POIs"
      data

    delete: ()->
      @model.destroy()
      @$el.remove()
      document.location = '#'

    editArea: ()->
      document.location = '#areas/' + @model.id + '/edit'

    rectOptions: ->
      {
        fill: false
        weight: 1
        color: @model.attributes.color

      }
