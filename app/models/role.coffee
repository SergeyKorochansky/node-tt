module.exports =
  identity: 'role'
  connection: 'default'
  attributes:
    name:
      type: 'string'
      required: true
    users:
      collection: 'user'
      via: 'role'
