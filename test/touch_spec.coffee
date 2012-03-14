{sinon} = require './spec_helper'
{touch} = require '../lib/frosting'
fs      = require 'fs'

describe 'touch', ->

  it 'should be defined', ->
    touch.should.be.ok

  it 'should create a new file', ->
    ( -> fs.statSync "#{__dirname}/support/foo.txt" ).should.throw( )

    touch "#{__dirname}/support/foo.txt"

    ( -> fs.statSync "#{__dirname}/support/foo.txt" ).should.not.throw( )

  it 'should create an empty file', ->
    touch "#{__dirname}/support/foo.txt"

    fs.readFileSync( "#{__dirname}/support/foo.txt", 'utf-8' ).should.equal ''
