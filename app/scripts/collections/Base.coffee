define [
  'models/base'
  'backbone'
], (BaseModel)->
  'use strict';

  BaseCollection = Backbone.Collection.extend
    model: BaseModel
