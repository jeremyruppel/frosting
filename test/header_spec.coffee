{File} = require '../lib/frosting'
fs     = require 'fs'

describe 'header', ->

  it 'should prepend the correct header to the buffer', ( done ) ->
    pkg = JSON.stringify
      name        : 'mymodule'
      version     : '0.2.5'
      author      : 'Foo, inc. <support@foo.com>'
      description : 'Handy stuff for the internets'
      repository  : {
        type      : 'git'
        url       : 'https://github.com/foo/mymodule'
      }
      license     : 'MIT'

    fs.writeFileSync "#{__dirname}/support/package.json", pkg, 'utf-8'

    foo = new File 'lib/foo.coffee'

    foo.append 'foo'

    foo.header "#{__dirname}/support/package.json", ->

      foo.buffer.should.equal """
      ###*
       * mymodule 0.2.5
       * Handy stuff for the internets
       * (c) 2012 Foo, inc. <support@foo.com>
       * Released under the MIT license.
       * For all details and documentation:
       * https://github.com/foo/mymodule
      ###
      foo
      """
      done( )
