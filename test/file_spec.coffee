{sinon} = require './spec_helper'
{File}  = require '../lib/frosting'

describe 'File', ->

  it 'should be defined', ->
    File.should.be.ok

  describe 'exists', ->

    it 'should return true for a file that exists', ->
      file = new File __filename
      file.exists( ).should.be.true

    it 'should return false for a file that doesnt exist', ->
      file = new File 'foo'
      file.exists( ).should.be.false

  describe 'read', ->

    it 'should return the contents of the file', ->
      file = new File __filename
      file.read( ).should.match /describe 'File'/
