module.exports =
  identity: 'project'
  connection: 'default'
  autoCreatedAt: true
  autoUpdatedAt: true
  attributes:
    name:
      type: 'string'
      required: true
    description:
      type: 'string'
#    users:
#      collection: 'user'
#      via: 'projects'
#      dominant: true
