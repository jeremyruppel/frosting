{sinon} = require './spec_helper'
{each}  = require '../lib/frosting'

describe 'each', ->

  it 'should be defined', ->
    each.should.be.ok

  it 'should call a callback for all glob matches', ( done ) ->
    spy = sinon.spy( )

    each "#{__dirname}/support/each/*.txt", spy, ->

      spy.callCount.should.equal 3

      done( )

  it 'should pass each filename to the callback', ( done ) ->
    spy = sinon.spy( )

    each "#{__dirname}/support/each/*.txt", spy, ->

      spy.firstCall.args[ 0 ].should.equal  "#{__dirname}/support/each/bar.txt"
      spy.secondCall.args[ 0 ].should.equal "#{__dirname}/support/each/baz.txt"
      spy.thirdCall.args[ 0 ].should.equal  "#{__dirname}/support/each/foo.txt"

      done( )
