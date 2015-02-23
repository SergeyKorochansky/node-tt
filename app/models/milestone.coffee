module.exports = (waterline) ->
  waterline.Collection.extend
    identity: 'milestone'
    connection: 'default'
    autoCreatedAt: true
    autoUpdatedAt: true
    attributes:
      name:
        type: 'string'
        required: true
      complete:
        type: 'integer'
        min: 0
        max: 100
      number:
        type: 'integer'
      project:
        model: 'project'
