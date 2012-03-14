{sinon}  = require './spec_helper'
{concat} = require '../lib/frosting'
fs       = require 'fs'

describe 'concat', ->

  beforeEach ->
    fs.writeFileSync "#{__dirname}/support/foo.txt", 'foo', 'utf-8'
    fs.writeFileSync "#{__dirname}/support/bar.txt", 'bar', 'utf-8'
    fs.writeFileSync "#{__dirname}/support/baz.txt", 'baz', 'utf-8'

  it 'should be defined', ->
    concat.should.be.ok

  it 'should read all files in a glob and yield a new file with everything in its buffer', ( done ) ->
    concat "#{__dirname}/support/*.txt", ( f ) ->

      f.buffer.should.equal """
      bar
      baz
      foo

      """
      done( )

  it 'should read all files in an array and yield a new file with everything in its buffer', ( done ) ->
    concat [
      "#{__dirname}/support/foo.txt",
      "#{__dirname}/support/bar.txt",
      "#{__dirname}/support/baz.txt"
    ], ( f ) ->

      f.buffer.should.equal """
      foo
      bar
      baz

      """
      done( )
