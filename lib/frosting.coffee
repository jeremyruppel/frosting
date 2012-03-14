fs     = require 'fs'
glob   = require 'glob'
coffee = require 'coffee-script'

###*
 * Shorter console.log
###
exports.puts = -> console.log arguments...

###*
 * Export `glob` straight up
###
exports.glob = glob

###*
 * Sugar method to call a block for each
 * filename matched in a glob
###
exports.each = ( pattern, callback, done ) ->

  glob pattern, { }, ( error, files ) ->

    callback file for file in files

    done?( )

###*
 *
###
exports.touch = ( file ) ->
  fs.writeFileSync file, '', 'utf-8'
  new File file

###*
 *
###
class File
  constructor : ( @path ) ->

  buffer : ''
  exists : ->
    try
      fs.statSync @path
      true
    catch error
      false

  read : -> @buffer = fs.readFileSync @path, 'utf-8'

  compile : ( callback ) ->
    @read( ) if @buffer is ''
    @buffer = coffee.compile @buffer
    callback( )

exports.File = File
