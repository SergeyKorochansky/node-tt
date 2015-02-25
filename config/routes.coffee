config = require './config'

module.exports = (app, passport) ->
  isLoggedIn = app.middlewares.auth.isLoggedIn
  isNotLoggedIn = app.middlewares.auth.isNotLoggedIn
  setLocals = app.middlewares.auth.setLocals

  app.get '/login', isNotLoggedIn, app.controllers.sessions.new
  app.post '/login', isNotLoggedIn, app.controllers.sessions.create(passport)

  app.get '/signup', isNotLoggedIn, app.controllers.users.new
  app.post '/signup', isNotLoggedIn, app.controllers.users.create(passport)

  app.get '/password-restore', isNotLoggedIn, app.controllers.users.restore
  app.post '/password-restore', isNotLoggedIn, app.controllers.users.restore

  app.all '*', isLoggedIn
  app.all '*', setLocals

  app.get '/', app.controllers.home.index
  app.post '/logout', app.controllers.sessions.destroy

