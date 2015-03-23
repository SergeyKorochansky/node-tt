express = require 'express'
session = require 'express-session'
compression = require 'compression'
gzipStatic = require 'connect-gzip-static'
morgan = require 'morgan'
cookieParser = require 'cookie-parser'
cookieSession = require 'cookie-session'
bodyParser = require 'body-parser'
methodOverride = require 'method-override'
csrf = require 'csurf'
multer = require 'multer'
mongoStore = require('connect-mongo')(session)
flash = require 'express-flash'
expressValidator = require 'express-validator'
config = require './config'

module.exports = (app, passport) ->
  app.use(compression())
  app.use(gzipStatic(config.static))
  app.use(morgan('dev'))
  app.set('view engine', 'jade')
  app.set('views', config.views)
  app.use(bodyParser.json())
  app.use(bodyParser.urlencoded(extended: true))
  app.use(multer())
  app.use(expressValidator())
  app.use(methodOverride((req) ->
    if req.body?.hasOwnProperty('_method')
      method = req.body._method
      delete req.body._method
      method
  ))
  app.use(cookieParser())
  app.use(cookieSession(secret: config.secret))
  app.use(session(
    resave: true
    saveUninitialized: true
    secret: config.secret
    store: new mongoStore(
      url: config.db.connections.default.url
      collection: 'sessions')))
  app.use(passport.initialize())
  app.use(passport.session())
  app.use(flash())

  if config.env == 'production'
    app.use(csrf())
    app.use((req, res, next) ->
      res.locals.csrfToken = req.csrfToken()
      next()
    )



