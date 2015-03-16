module.exports =
  identity: 'project'
  connection: 'default'
  autoCreatedAt: true
  autoUpdatedAt: true
  attributes:
    name:
      type: 'string'
      required: true
      maxLength: 100
    description:
      type: 'string'
      maxLength: 10000
#    users:
#      collection: 'user'
#      via: 'projects'
#      dominant: true
