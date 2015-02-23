mongoAdapter = require 'sails-mongo'

module.exports =
  db:
    url: 'mongodb://localhost:27017/node-tt'
    adapters:
      mongo: mongoAdapter
    connections:
      default:
        adapter: 'mongo'
        module: 'sails-mongo'
        host: 'localhost'
        port: 27017
        database: 'node-tt'
    defaults:
      migrate: 'alter'
      autoPK: true
      autoCreatedAt: false
      autoUpdatedAt: false
