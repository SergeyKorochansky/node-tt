waterline = require 'waterline'
requireAll = require 'require-all'
config = require './config'

module.exports =
  initialize: (orm) ->
    requireAll
      dirname: config.models
      filter: /\.js$/
      resolve: (model) ->
        collection = waterline.Collection.extend model
        orm.loadCollection collection
  initializeHooks: (collections) ->
    requireAll
      dirname: config.models
      filter: /\.js$/
      resolve: (model) ->
        if model.customCallbacks?
          for type, callback of model.customCallbacks
            collections[model.identity]
            ._callbacks[type]
            .push callback(collections[model.identity])

    collections

