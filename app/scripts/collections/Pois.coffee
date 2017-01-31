define [
  'collections/base'
  'models/poi'
  'models/stores'
], (BaseCollection, POI, Stores)->
  'use strict';

  POI.Collection = BaseCollection.extend
    model: POI
    localStorage: Stores.Pois
