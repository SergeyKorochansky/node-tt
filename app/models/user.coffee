bcrypt = require 'bcrypt'

generateHash = (user, cb) ->
  if user.password?
    bcrypt.genSalt 10, (err, salt) ->
      bcrypt.hash user.password, salt, (err, hash) ->
        if (err)
          cb(err)
        else
          user.password = hash
          cb()
  else
    cb()

comparePasswords = (candidatePassword, cb) ->
  bcrypt.compare(candidatePassword, @password, cb)

module.exports =
  identity: 'user'
  connection: 'default'
  autoCreatedAt: true
  autoUpdatedAt: true
  uniqueEmail: false
  types:
    uniqueEmail: ->
      global.uniqueEmail

  attributes:
    email:
      type: 'email'
      required: true
      unique: true
      uniqueEmail: true
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
    projects:
      collection: 'project'
      via: 'users'
  beforeCreate: generateHash
  beforeUpdate: generateHash

  customCallbacks:
    beforeValidate: (User) ->
      (values, next) ->
        User
        .findOneByEmail(values.email)
        .exec (err, user) ->
          global.uniqueEmail = !err && (!user || values.id == user.id)
          next()
