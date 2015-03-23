waterline = require 'waterline'
async = require 'async'
config = require './config'
models = require './models'

orm = new waterline()

models.initialize(orm)

orm.initialize config.db, (err, data) ->
  throw err if err
  readyModels = models.initializeHooks(data.collections)

  Role = readyModels.role
  User = readyModels.user

  async.waterfall [
    (cb) ->
      User.destroy({})
      .exec (err) ->
        cb(err)
    (cb) ->
      Role.destroy({})
      .exec (err) ->
        cb(err)
    (cb) ->
      Role.create [
        {name: 'admin'}
        {name: 'manager'}
        {name: 'client'}
      ]
      .exec (err, roles) ->
        cb(err, roles)
    (roles, cb) ->
      User.create [
        {
          email: 'admin@company.com'
          password: '123456'
          firstName: 'John'
          lastName: 'Doe'
          role: roles[0].id
        }
        {
          email: 'manager@company.com'
          password: '123456'
          firstName: 'Tom'
          lastName: 'Tacker'
          role: roles[1].id
        }
        {
          email: 'client@company.com'
          password: '123456'
          firstName: 'Artur'
          lastName: 'Bison'
          role: roles[2].id
        }
      ]
      .exec (err, users) ->
        cb(err, users)
  ], (err, users) ->
    if !err && users
      console.log 'Successfully!'
    else
      console.log err
    process.exit()
