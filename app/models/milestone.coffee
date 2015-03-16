module.exports =
  identity: 'milestone'
  connection: 'default'
  autoCreatedAt: true
  autoUpdatedAt: true
  attributes:
    name:
      type: 'string'
      required: true
      maxLength: 100
    complete:
      type: 'integer'
      min: 0
      max: 100
    number:
      type: 'integer'
    project:
      model: 'project'
