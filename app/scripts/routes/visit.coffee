define [
  'jquery',
  'backbone',
  'views/visit/home'
  'views/allareas'
  'views/visit/areafull'
  'views/newarea'
  'views/editarea'
  'views/settings'
  'views/newpoi'
  'views/editpoi'
  'models/area'
  'models/poi'
], ($, Backbone, VisitHomeView, AllAreasView, AreaFullView, NewAreaView, EditAreaView, SettingsView, NewPOIView, EditPOIView, Area, POI) ->
  'use strict';

  VisitRouter = Backbone.Router.extend
    routes: {
      "": "home"
      "areas/:oid": "area"
    }

    initialize: () ->

    show: (view, url)->
      @view?.clean()
      @view?.remove()
      @view = view
      @view.render()
      @navigate url if url?
      window.planMyTrip.hideDrawer()

    home: ->
      @show new VisitHomeView

    area: (id)->
      new Area(id: id).fetch
        success: (o)=>
          @show new AreaFullView model: o
