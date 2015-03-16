module.exports =
  identity: 'city'
  connection: 'default'
  attributes:
    name:
      type: 'string'
      required: true
      unique: true
      maxLength: 100
    users:
      collection: 'user'
      via: 'city'
