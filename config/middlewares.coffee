requireAll = require 'require-all'
config = require './config'

module.exports = ->
  requireAll
    dirname: config.middlewares
    filter: /(.+)\.coffee$/
