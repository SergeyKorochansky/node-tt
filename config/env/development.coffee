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

  mailgun:
    user: 'postmaster@sandbox9ed13e55b9bb4706ad96ab32dafb424b.mailgun.org'
    password: '029c4266ce20c2724188c094a111f123'
