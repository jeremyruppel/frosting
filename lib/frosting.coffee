fs               = require 'fs'
path             = require 'path'
glob             = require 'glob'
ejs              = require 'ejs'
coffee           = require 'coffee-script'
{exec}           = require 'child_process'
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
 * `exec`, but with logging
###
exports.sh = ( command, callback ) ->

  exec command, ( errors, stdout, stderr ) ->

    console.log errors if error?
    console.log stdout if stdout?
    console.log stderr if stderr?

    callback( errors, stdout, stderr ) if callback?

###*
 * Shorter `renameSync`
###
exports.mv = ( from, to ) -> fs.renameSync from, to

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
    if f.exists( )
      file.append f.read( )
    else
      file.append f.path
  , -> callback file

###*
 *
###
exports.touch = ( file ) -> new File( file ).write( )

###*
 *
###
exports.package = JSON.parse fs.readFileSync( 'package.json', 'utf8' )

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

  append : ( string ) ->
    @buffer = if @buffer.length is 0 then string else "#{@buffer}\n#{string}"

  prepend : ( string ) ->
    @buffer = if @buffer.length is 0 then string else "#{string}\n#{@buffer}"

  read : ->
    context = process : process, package : exports.package
    @buffer = ejs.render fs.readFileSync( @path, 'utf-8' ), context

  write : ( path=@path ) ->
    fs.writeFileSync path, @buffer, 'utf-8'
    @

  compile : ( callback ) ->
    @read( ) if @buffer is ''

    @buffer = coffee.compile @buffer

    callback @

  minify : ( callback ) ->
    @read( ) if @buffer is ''

    ast = parser.parse @buffer
    ast = uglify.ast_mangle ast
    ast = uglify.ast_squeeze ast

    @buffer = uglify.gen_code ast

    callback @

  header : ( json, callback ) ->
    fs.readFile json, 'utf-8', ( err, data ) =>
      pkg = JSON.parse data
      @prepend """
      ###*
       * #{pkg.name} #{pkg.version}
       * #{pkg.description}
       * (c) #{new Date( ).getFullYear( )} #{pkg.author}
       * Released under the #{pkg.license} license.
       * For all details and documentation:
       * #{pkg.repository.url}
      ###
      """
      callback( )

exports.File = File
