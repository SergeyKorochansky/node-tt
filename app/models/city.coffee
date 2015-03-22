module.exports =
  identity: 'city'
  connection: 'default'
  uniqueName: false
  types:
    uniqueName: ->
      global.uniqueName
  attributes:
    name:
      type: 'string'
      required: true
      unique: true
      uniqueName: true
      maxLength: 100
    users:
      collection: 'user'
      via: 'city'
  customCallbacks:
    beforeValidate: (City) ->
      (values, next) ->
        City
        .findOneByName(values.name)
        .exec (err, city) ->
          global.uniqueName = !err && (!city || values.id == city.id)
          next()