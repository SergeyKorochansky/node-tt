express = require('express')
session = require('express-session')
compression = require('compression')
morgan = require('morgan')
cookieParser = require('cookie-parser')
cookieSession = require('cookie-session')
bodyParser = require('body-parser')
methodOverride = require('method-override')
csrf = require('csurf')
multer = require('multer')
mongoStore = require('connect-mongo')(session)
flash = require('connect-flash')
config = require('./config')

module.exports = (app, passport) ->
  app.use(compression())
  app.use(express.static(config.root + '/public'))
  app.use(morgan('dev'))
  app.set('view engine', 'jade')
  app.use(bodyParser.json())
  app.use(bodyParser.urlencoded(extended: true))
  app.use(multer())
  app.use(methodOverride((req, res) ->
    if req.body && typeof req.body == 'object' && '_method' in req.body
      # look in urlencoded POST bodies and delete it
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
      url: config.db.url
      collection: 'sessions')))
  app.use(passport.initialize())
  app.use(passport.session())
  app.use(flash())

  if config.env == 'production'
    app.use(csrf(cookie: true))


