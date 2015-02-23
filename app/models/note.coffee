module.exports = (waterline) ->
  waterline.Collection.extend
    identity: 'note'
    connection: 'default'
    autoCreatedAt: true
    autoUpdatedAt: true
    attributes:
      name:
        type: 'string'
        required: true
      content:
        type: 'string'
      user:
        model: 'user'
      milestone:
        model: 'milestone'
