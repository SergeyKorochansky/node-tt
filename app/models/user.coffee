module.exports = (waterline) ->
  waterline.Collection.extend
    identity: 'user'
    connection: 'default'
    autoCreatedAt: true
    autoUpdatedAt: true
    attributes:
      email:
        type: 'string'
        required: true
        unique: true
      hash:
        type: 'string'
        required: true
      salt:
        type: 'string'
        required: true
      firstName:
        type: 'string'
      lastName:
        type: 'string'
      city:
        model: 'city'
      role:
        model: 'role'
#      projects:
#        collection: 'project'
#        via: 'users'
