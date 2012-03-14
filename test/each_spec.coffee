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

  it 'should pass a File object to each callback', ( done ) ->
    spy = sinon.spy( )

    each "#{__dirname}/support/*.txt", spy, ->

      spy.getCall( 0 ).args[ 0 ].should.be.a 'object'
      spy.getCall( 0 ).args[ 0 ].path.should.equal "#{__dirname}/support/bar.txt"
      spy.getCall( 1 ).args[ 0 ].should.be.a 'object'
      spy.getCall( 1 ).args[ 0 ].path.should.equal "#{__dirname}/support/baz.txt"
      spy.getCall( 2 ).args[ 0 ].should.be.a 'object'
      spy.getCall( 2 ).args[ 0 ].path.should.equal "#{__dirname}/support/foo.txt"

      done( )

  it 'should iterate over an array of files if provided one', ( done ) ->
    spy = sinon.spy( )

    each [ 'foo.txt', 'bar.txt', 'baz.txt' ], spy, ->

      spy.getCall( 0 ).args[ 0 ].should.be.a 'object'
      spy.getCall( 0 ).args[ 0 ].path.should.equal "foo.txt"
      spy.getCall( 1 ).args[ 0 ].should.be.a 'object'
      spy.getCall( 1 ).args[ 0 ].path.should.equal "bar.txt"
      spy.getCall( 2 ).args[ 0 ].should.be.a 'object'
      spy.getCall( 2 ).args[ 0 ].path.should.equal "baz.txt"

      done( )
