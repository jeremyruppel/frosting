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

  describe 'buffer', ->

    it 'should be blank initially', ->
      file = new File __filename
      file.buffer.should.equal ''

  describe 'read', ->

    it 'should return the contents of the file', ->
      file = new File __filename
      file.read( ).should.match /describe 'File'/

    it 'should assign the file contents to the buffer', ->
      file = new File __filename
      file.read( )
      file.buffer.should.match /describe 'File'/

  describe 'compile', ->

    it 'should call read if the buffer is empty', ( done ) ->
      file = new File __filename
      sinon.spy file, 'read'

      file.buffer.should.equal ''
      file.read.called.should.be.false

      file.compile ->
        file.read.called.should.be.true
        done( )

    it 'should not call read if the buffer is not empty', ( done ) ->
      file = new File __filename
      sinon.spy file, 'read'

      file.buffer = 'foo'
      file.read.called.should.be.false

      file.compile ->
        file.read.called.should.be.false
        done( )

    it 'should pass the contents of the buffer through the coffeescript compiler', ( done ) ->
      file = new File __filename
      file.buffer = 'foo = -> "bar"'

      file.compile ->
        file.buffer.should.eql """
        (function() {
          var foo;

          foo = function() {
            return "bar";
          };

        }).call(this);

        """
        done( )

  describe 'minify', ->

    it 'should call read if the buffer is empty', ( done ) ->
      file = new File __filename
      sinon.stub( file, 'read' ).returns 'var foo = "bar";'

      file.buffer.should.equal ''
      file.read.called.should.be.false

      file.minify ->
        file.read.called.should.be.true
        done( )

    it 'should not call read if the buffer is not empty', ( done ) ->
      file = new File __filename
      sinon.stub( file, 'read' ).returns 'var foo = "bar";'

      file.buffer = 'foo'
      file.read.called.should.be.false

      file.minify ->
        file.read.called.should.be.false
        done( )

    it 'should pass the contents of the buffer through the uglifyjs minifier', ( done ) ->
      file = new File __filename
      file.buffer = 'var foo = "bar";'

      file.minify ->
        file.buffer.should.eql 'var foo="bar"'
        done( )
