{sinon} = require './spec_helper'
{glob}  = require '../lib/frosting'

describe 'glob', ->

  it 'should be defined', ->
    glob.should.be.ok

  it 'should simply export the glob module', ->
    glob.should.equal require 'glob'
