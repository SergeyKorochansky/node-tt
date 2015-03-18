express = require 'express'
passport = require 'passport'
waterline = require 'waterline'
config = require './config/config'
models = require './config/models'

app = express()
orm = new waterline()

models.initialize(orm)

orm.initialize config.db, (err, data) ->
  throw err if err

  app.models = models.initializeHooks(data.collections)
  app.connections = data.connections

  app.controllers = require('./config/controllers')(app)
  app.middlewares = require('./config/middlewares')()

  require('./config/passport')(app.models.user, passport)
  require('./config/express')(app, passport)
  require('./config/controllers')(app)
  require('./config/routes')(app, passport)

  app.listen(config.server.port, config.server.hostname)
