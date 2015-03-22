mongoAdapter = require 'sails-mongo'

module.exports =
  db:
    adapters:
      mongo: mongoAdapter
    connections:
      default:
        adapter: 'mongo'
        url: process.env.MONGOLAB_URI
    defaults:
      migrate: 'alter'
      autoPK: true
      autoCreatedAt: false
      autoUpdatedAt: false

  mailgun:
    user: 'postmaster@sandbox9ed13e55b9bb4706ad96ab32dafb424b.mailgun.org'
    password: '029c4266ce20c2724188c094a111f123'

  server:
    port: process.env.PORT
