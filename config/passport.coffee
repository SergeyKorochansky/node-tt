LocalStrategy = require('passport-local').Strategy

module.exports = (userModel, passport) ->
  serialize = (user, done) ->
    done(null, user.id)

  deserialize = (id, done) ->
    userModel.findOne(id: id, (err, user) ->
      done(err, user)
    )

  passport.serializeUser(serialize)
  passport.deserializeUser(deserialize)

  fieldNames =
    usernameField: 'email'
    passwordField: 'hash'

  strategyFunction = (email, password, done) ->
    User.findOne(email: email, (err, user) ->
      if err
        return done(err)
      if !user
        return done(null, false, message: 'Unknown user')
      if !user.authenticate(password)
        return done(null, false, message: 'Invalid password')
      done(null, user)
    )

  passport.use(new LocalStrategy(fieldNames, strategyFunction))