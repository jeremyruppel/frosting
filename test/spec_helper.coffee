exports.should = require 'should'
exports.sinon  = require 'sinon'

fs = require 'fs'

afterEach ->
  for file in fs.readdirSync "#{__dirname}/support"
    fs.unlinkSync "#{__dirname}/support/#{file}" unless file is '.gitkeep'
