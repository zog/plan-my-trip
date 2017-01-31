define [
  'backboneLocalstorage',
], (Store)->
  'use strict';

  Stores = {
      Pois: new Store('plan-my-trip-pois')
      Areas: new Store('plan-my-trip-areas')
      Settings: new Store('plan-my-trip-settings')
    }
