glob = require 'glob'

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
