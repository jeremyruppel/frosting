fs               = require 'fs'
path             = require 'path'
glob             = require 'glob'
coffee           = require 'coffee-script'
{uglify, parser} = require 'uglify-js'

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
 * filename matched in a glob, or for each
 * filename in an array of filenames
###
each = ( files, callback, done ) ->

  if typeof files is 'string'
    glob files, { }, ( error, files ) ->
      callback new File( file ) for file in files
      done?( )
  else
    callback new File( file ) for file in files
    done?( )

exports.each = each

###*
 *
###
exports.concat = ( files, callback ) ->

  file = new File( )
  each files, ( f ) ->
    file.buffer += f.read( ) + "\n"
  , ->
    callback file

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

  filename : -> path.basename @path

  extname : -> path.extname @path

  basename : -> path.basename @path, @extname( )

  append : ( string ) -> @buffer = "#{@buffer}\n#{string}"

  prepend : ( string ) -> @buffer = "#{string}\n#{@buffer}"

  read : -> @buffer = fs.readFileSync @path, 'utf-8'

  write : ( path=@path ) -> fs.writeFileSync path, @buffer, 'utf-8'

  compile : ( callback ) ->
    @read( ) if @buffer is ''

    @buffer = coffee.compile @buffer

    callback( )

  minify : ( callback ) ->
    @read( ) if @buffer is ''

    ast = parser.parse @buffer
    ast = uglify.ast_mangle ast
    ast = uglify.ast_squeeze ast

    @buffer = uglify.gen_code ast

    callback( )

exports.File = File
