config = require './config'

module.exports = (app, passport) ->
  isLoggedIn = app.middlewares.auth.isLoggedIn
  isNotLoggedIn = app.middlewares.auth.isNotLoggedIn
  setLocals = app.middlewares.auth.setLocals
  errorHandlers = app.middlewares.error

  app.get '/login', isNotLoggedIn, app.controllers.sessions.new
  app.post '/login', isNotLoggedIn, app.controllers.sessions.create(passport)

  app.get '/signup', isNotLoggedIn, app.controllers.users.new
  app.post '/signup', isNotLoggedIn, app.controllers.users.create(passport)

  app.get '/forgot', isNotLoggedIn, app.controllers.forgot.showEmailForm
  app.post '/forgot', isNotLoggedIn, app.controllers.forgot.sendMail
  app.get '/reset/:token', isNotLoggedIn, app.controllers.forgot.showNewPasswordForm
  app.post '/reset/:token', isNotLoggedIn, app.controllers.forgot.saveNewPassword

  app.all '*', isLoggedIn
  app.all '*', setLocals

  app.get '/', app.controllers.home.index
  app.post '/logout', app.controllers.sessions.destroy

  app.use errorHandlers.notFound
  app.use errorHandlers.internalError
