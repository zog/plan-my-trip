define [
  'collections/base'
  'models/area'
  'models/stores'
  'backbone'
], (BaseCollection, Area, Stores)->
  'use strict';

  AreasCollection = BaseCollection.extend
    model: Area
    localStorage: Stores.Areas
