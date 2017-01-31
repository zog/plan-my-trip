define [
  'views/visit/base'
  'views/allareas'
], (BaseView, AllAreasView)->
  'use strict';

  console.log BaseView
  Homeview = BaseView.extend
    template: JST['visit/Home']

    customRender: () ->
      v = new AllAreasView()
      v.render()
      @subviews.push v
      @$el.append v.$el
      window.planMyTrip.setTabTitle "Areas"
      @mapView.resetCenter()

