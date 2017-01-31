this.JST = this.JST || {}

require.config
  shim: {
    underscore: {
      exports: '_'
    },
    backbone: {
      deps: ["underscore", "jquery"],
      exports: "Backbone"
    },
    backboneLocalstorage: {
      deps: ['backbone'],
      exports: 'Store'
    }
    "leaflet.draw": {
      deps: ['leaflet']
    }
    planMyTrip: {
      deps: ['backbone'],
      exports: 'PlanMyTrip'
    }
    offlinemap: {
      deps: ['leaflet']
    }
  }
  paths: {
    jquery: '../bower_components/jquery/dist/jquery',
    underscore: '../bower_components/underscore/underscore',
    backbone: '../bower_components/backbone/backbone',
    backboneLocalstorage: '../bower_components/backbone.localStorage/backbone.localStorage',
    leaflet: '../bower_components/leaflet/dist/leaflet',
    async: '../bower_components/async/dist/async',
    "idb-wrapper": '../bower_components/idb-wrapper/idbstore',
    offlinemap: 'models/offlinemap',
  }

require [
  'jquery',
  'planmytrip',
],  ($, PlanMyTrip) ->
  $ ->
    'use strict'
    window.planMyTrip = new PlanMyTrip
    window.planMyTrip.render()

