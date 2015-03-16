module.exports =
  identity: 'role'
  connection: 'default'
  attributes:
    name:
      type: 'string'
      required: true
      maxLength: 100
    users:
      collection: 'user'
      via: 'role'
