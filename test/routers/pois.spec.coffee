# global beforeEach, describe, it, assert, expect
"use strict"

describe 'Pois Router', ->
  beforeEach ->
    @PoisRouter = new PlanMyTrip.Routers.Pois();

  it 'index route', ->

