# global beforeEach, describe, it, assert, expect
"use strict"

describe 'POI Model', ->
  beforeEach ->
    @POIModel = new PlanMyTrip.Models.POI();
