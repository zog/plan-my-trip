define [
  'jquery',
  'backbone',
  'views/allareas'
  'views/areafull'
  'views/newarea'
  'views/editarea'
  'views/settings'
  'views/newpoi'
  'views/editpoi'
  'models/area'
  'models/poi'
], ($, Backbone, AllAreasView, AreaFullView, NewAreaView, EditAreaView, SettingsView, NewPOIView, EditPOIView, Area, POI) ->
  'use strict';

  AppRouter = Backbone.Router.extend
    routes: {
      "": "home",
      "settings": "settings"
      "areas/new": "new_area"
      "areas/:oid": "area"
      "areas/:oid/edit": "edit_area"
      "areas/:oid/pois/new": "new_poi"
      "areas/:oid/pois/:poiId/edit": "edit_poi"
    }

    initialize: () ->

    show: (view, url)->
      @view?.clean()
      @view?.remove()
      @view = view
      @view.render()
      @navigate url if url?

    home: ->
      @show new AllAreasView
      window.planMyTrip.map.resetCenter()

    settings: ->
      @show new SettingsView

    new_poi: (id)->
      new Area(id: id).fetch
        success: (o)=>
          @show new NewPOIView(o)

    edit_poi: (id, poiId)->
      new Area(id: id).fetch
        success: (a)=>
          new POI(id: poiId).fetch
            success: (o)=>
              @show new EditPOIView(a, o)

    area: (id)->
      new Area(id: id).fetch
        success: (o)=>
          @show new AreaFullView model: o

    new_area: ->
      @show new NewAreaView

    edit_area: (id)->
      new Area(id: id).fetch
        success: (o)=>
          @show new EditAreaView model: o
