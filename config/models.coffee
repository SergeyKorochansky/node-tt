waterline = require 'waterline'
requireAll = require 'require-all'
config = require './config'

module.exports = (orm) ->
  requireAll
    dirname: config.models
    filter: /\.coffee$/
    resolve: (model) ->
      collection = waterline.Collection.extend model
      orm.loadCollection collection
