requireAll = require 'require-all'
config = require './config'

module.exports = (app) ->
  requireAll
    dirname: config.controllers
    filter: /(.+)\.coffee$/
    resolve: (controller) ->
      new controller(app)
