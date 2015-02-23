module.exports = (waterline) ->
  waterline.Collection.extend
    identity: 'city'
    connection: 'default'
    attributes:
      name:
        type: 'string'
        required: true
        unique: true
      users:
        collection: 'user'
        via: 'city'
