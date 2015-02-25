waterline = require 'waterline'
config = require './config'

orm = new waterline()

require('./models')(orm)

orm.initialize config.db, (err, models) ->
  throw err if err

  User = models.collections.user

  User.create
    email: 'john@doe.com'
    password: '123456'
    firstName: 'John'
    lastName: 'Doe'
