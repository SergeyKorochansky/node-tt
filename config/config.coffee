path = require 'path'
extend = require('util')._extend

development = require './env/development'
test = require './env/test'
production = require './env/production'

rootPath = path.normalize(__dirname + '/..')

settings =
  root: rootPath
  controllers: "#{rootPath}/app/controllers"
  models: "#{rootPath}/app/models"
  middlewares: "#{rootPath}/app/middlewares"
  views: "#{rootPath}/app/views/"
  static: "#{rootPath}/public"

  server:
    port: process.env.PORT || '3000'

  secret: process.env.SECRET || 'secret'
  env: process.env.NODE_ENV || 'development'


module.exports =
  switch settings.env
    when 'development' then extend(development, settings)
    when 'test' then extend(test, settings)
    when 'production' then extend(production, settings)
