{sinon} = require './spec_helper'
{each}  = require '../lib/frosting'
fs      = require 'fs'

describe 'each', ->

  beforeEach ->
    fs.writeFileSync "#{__dirname}/support/foo.txt", 'foo', 'utf-8'
    fs.writeFileSync "#{__dirname}/support/bar.txt", 'bar', 'utf-8'
    fs.writeFileSync "#{__dirname}/support/baz.txt", 'baz', 'utf-8'

  it 'should be defined', ->
    each.should.be.ok

  it 'should call a callback for all glob matches', ( done ) ->
    spy = sinon.spy( )

    each "#{__dirname}/support/*.txt", spy, ->

      spy.callCount.should.equal 3

      done( )

  it 'should pass each filename to the callback', ( done ) ->
    spy = sinon.spy( )

    each "#{__dirname}/support/*.txt", spy, ->

      spy.firstCall.args[ 0 ].should.equal  "#{__dirname}/support/bar.txt"
      spy.secondCall.args[ 0 ].should.equal "#{__dirname}/support/baz.txt"
      spy.thirdCall.args[ 0 ].should.equal  "#{__dirname}/support/foo.txt"

      done( )
