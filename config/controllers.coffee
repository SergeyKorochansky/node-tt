requireAll = require 'require-all'
config = require './config'

module.exports = (app) ->
  requireAll
    dirname: config.controllers
    filter: /(.+)\.(js|coffee)$/
    resolve: (controller) ->
      new controller(app)
