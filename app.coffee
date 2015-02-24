express = require 'express'
passport = require 'passport'
waterline = require 'waterline'
config = require './config/config'

app = express()
orm = new waterline()

require('./config/models')(orm)

orm.initialize config.db, (err, models) ->
  throw err if err

  app.models = models.collections
  app.connections = models.collections
  app.controllers = require('./config/controllers')()
  app.middlewares = require('./config/middlewares')()

  require('./config/passport')(app.models.user, passport)
  require('./config/express')(app, passport)
  require('./config/controllers')(app)
  require('./config/routes')(app, passport)

  app.listen(config.server.port, config.server.hostname)
