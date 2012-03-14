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

  describe 'filename', ->

    it 'should return the correct filename', ->
      file = new File __filename
      file.filename( ).should.equal 'file_spec.coffee'

  describe 'extname', ->

    it 'should return the correct extname', ->
      file = new File __filename
      file.extname( ).should.equal '.coffee'

  describe 'basename', ->

    it 'should return the correct basename', ->
      file = new File __filename
      file.basename( ).should.equal 'file_spec'

  describe 'buffer', ->

    it 'should be blank initially', ->
      file = new File __filename
      file.buffer.should.equal ''

  describe 'append', ->

    it 'should append a string to the buffer', ->
      file = new File __filename
      file.buffer = 'foo'
      file.append 'bar'
      file.buffer.should.equal "foo\nbar"

  describe 'prepend', ->

    it 'should prepend a string to the buffer', ->
      file = new File __filename
      file.buffer = 'foo'
      file.prepend 'bar'
      file.buffer.should.equal "bar\nfoo"

  describe 'read', ->

    it 'should return the contents of the file', ->
      file = new File __filename
      file.read( ).should.match /describe 'File'/

    it 'should assign the file contents to the buffer', ->
      file = new File __filename
      file.read( )
      file.buffer.should.match /describe 'File'/

  describe 'write', ->

    it 'should create a new file if one does not exist', ->
      file = new File "#{__dirname}/support/foo.txt"
      file.exists( ).should.be.false
      file.write( )
      file.exists( ).should.be.true

    it 'should write the buffer to the File path if no filename is given', ->
      file = new File "#{__dirname}/support/foo.txt"
      file.buffer = 'foo'
      file.write( )
      file.read( ).should.equal 'foo'

    it 'should write the buffer to another path if a filename is given', ->
      foo = new File "#{__dirname}/support/foo.txt"
      foo.buffer = 'foo'
      foo.write "#{__dirname}/support/bar.txt"

      foo.exists( ).should.be.false

      bar = new File "#{__dirname}/support/bar.txt"
      bar.exists( ).should.be.true
      bar.read( ).should.equal 'foo'

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
