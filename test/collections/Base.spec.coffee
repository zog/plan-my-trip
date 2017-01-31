# global beforeEach, describe, it, assert, expect
"use strict"

describe 'Base Collection', ->
  beforeEach ->
    @BaseCollection = new PlanMyTrip.Collections.Base()
