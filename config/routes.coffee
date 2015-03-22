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

  app.get '/profile', app.controllers.users.edit

  app.post '/logout', app.controllers.sessions.destroy

  app.get '/cities', app.controllers.cities.index
  app.get '/cities/new', app.controllers.cities.new
  app.post '/cities', app.controllers.cities.create
  app.get '/cities/:id/edit', app.controllers.cities.edit
  app.patch '/cities/:id', app.controllers.cities.update
  app.delete '/cities/:id', app.controllers.cities.destroy

  app.get '/users', app.controllers.users.index
  app.patch '/users/:id', app.controllers.users.update
  app.delete '/users/:id', app.controllers.users.destroy

  app.get '/projects/', app.controllers.projects.index
  app.get '/projects/new', app.controllers.projects.new
  app.post '/projects/', app.controllers.projects.create
  app.get '/projects/:id', app.controllers.projects.show
  app.get '/projects/:id/edit', app.controllers.projects.edit
  app.patch '/projects/:id', app.controllers.projects.update
  app.delete '/projects/:id', app.controllers.projects.destroy

  app.get '/milestones/new', app.controllers.milestones.new
  app.post '/milestones', app.controllers.milestones.create
  app.get '/milestones/:id', app.controllers.milestones.show
  app.get '/milestones/:id/edit', app.controllers.milestones.edit
  app.patch '/milestones/:id', app.controllers.milestones.update
  app.delete '/milestones/:id', app.controllers.milestones.destroy

  app.use errorHandlers.notFound
  app.use errorHandlers.validationError
  app.use errorHandlers.internalError
