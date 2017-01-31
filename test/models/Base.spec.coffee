# global beforeEach, describe, it, assert, expect
"use strict"

describe 'Base Model', ->
  beforeEach ->
    @BaseModel = new PlanMyTrip.Models.Base();
