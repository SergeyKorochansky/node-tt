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
  bcrypt.compare(candidatePassword, @password, cb)

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
      maxLength: 100
    password:
      type: 'string'
      minLength: 6
      required: true
      columnName: 'hash'
    firstName:
      type: 'string'
      required: true
      minLength: 3
      maxLength: 100
    lastName:
      type: 'string'
      required: true
      minLength: 3
      maxLength: 100
    resetPasswordToken:
      type: 'string'
    resetPasswordExpires:
      type: 'datetime'
    city:
      model: 'city'
    role:
      model: 'role'
    comparePasswords: comparePasswords
    fullName: ->
      "#{@firstName} #{@lastName}"
#    projects:
#      collection: 'project'
#      via: 'users'
  beforeCreate: generateHash
  beforeUpdate: generateHash
