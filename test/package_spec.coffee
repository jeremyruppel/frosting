{package} = require '../lib/frosting'

describe 'package', ->

  it 'should be defined', ->
    package.should.be.ok

  it 'should have the current package.json parsed', ->
    package.name.should.equal 'frosting'
