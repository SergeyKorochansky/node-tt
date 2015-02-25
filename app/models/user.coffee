bcrypt = require 'bcrypt'

generateHash = (user, cb) ->
  bcrypt.genSalt 10, (err, salt) ->
    bcrypt.hash user.password, salt, (err, hash) ->
      if (err)
        cb(err)
      else
        user.password = hash
        cb()

comparePasswords = (candidatePassword, cb) ->
  bcrypt.compare(candidatePassword, this.password, cb)

module.exports =
  identity: 'user'
  connection: 'default'
  autoCreatedAt: true
  autoUpdatedAt: true
  attributes:
    email:
      type: 'email'
      required: true
      unique: true
      lowercase: true
    password:
      type: 'string'
      minLength: 6
      required: true
      columnName: 'hash'
    firstName:
      type: 'string'
    lastName:
      type: 'string'
    city:
      model: 'city'
    role:
      model: 'role'
    comparePasswords: comparePasswords
#    projects:
#      collection: 'project'
#      via: 'users'
  beforeCreate: generateHash
  beforeUpdate: generateHash
