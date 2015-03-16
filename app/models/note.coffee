module.exports =
  identity: 'note'
  connection: 'default'
  autoCreatedAt: true
  autoUpdatedAt: true
  attributes:
    name:
      type: 'string'
      required: true
      maxLength: 100
    content:
      type: 'string'
      maxLength: 10000
    user:
      model: 'user'
    milestone:
      model: 'milestone'
