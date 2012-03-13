{sinon} = require './spec_helper'
{puts}  = require '../lib/frosting'

describe 'puts', ->

  it 'should be defined', ->
    puts.should.be.ok

  it 'should pass all arguments to console.log', ->
    mock = sinon.mock console
    mock.expects( 'log' ).once( ).withExactArgs 'foo', 'bar', 'baz'

    puts 'foo', 'bar', 'baz'

    mock.verify( )
