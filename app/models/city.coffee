module.exports =
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
