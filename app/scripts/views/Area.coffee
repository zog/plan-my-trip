define [
  'views/base'
  'routes/app'
  'views/areafull'
], (BaseView, AppRouter, AreaFullView)->
  'use strict';

  AreaView = BaseView.extend

    template: JST['Area']

    className: ''

    tagName: 'tr'

    events: {
      "click .delete": "delete"
      "click .name": "showFull"
      "click .edit": "editArea"
    }

    initialize: () ->
      @listenTo @model, 'change', @render

    render: () ->
      data = @model.toJSON()
      @$el.html @template(data)
      @showMap data, false, false

    rectOptions: ->
      {
        fill: true
        weight: 1
        color: @model.attributes.color
        fillColor: @model.attributes.color
      }

    delete: ()->
      @model.destroy()
      @$el.remove()

    showFull: ()->
      document.location = window.planMyTrip.decorateUrl 'areas/' + @model.id

    editArea: ()->
      document.location =  window.planMyTrip.decorateUrl 'areas/' + @model.id + '/edit'
