LocalStrategy = require('passport-local').Strategy

module.exports = (userModel, passport) ->
  serialize = (user, done) ->
    done(null, user.id)

  deserialize = (id, done) ->
    userModel.findOne id: id, (err, user) ->
      done(err, user)


  passport.serializeUser(serialize)
  passport.deserializeUser(deserialize)

  fieldNames =
    usernameField: 'email'
#    passwordField: 'password'

  localLogin = (email, password, done) ->
    userModel.findOne email: email, (err, user) ->
#      console.log user
      if err
        done(err)
      else if !user
        done(null, false, message: 'Unknown user')
      else user.comparePasswords password, (err, matched) ->
        if matched
          done(null, user)
        else
          done(null, false, message: 'Invalid password')


  passport.use('local-login', new LocalStrategy(fieldNames, localLogin))

  localSignUp = (email, password, done) ->
    userModel.create email: email, password: password, (err, user) ->
      if err
        return done(err)
      done(null, user)

  passport.use('local-signup', new LocalStrategy(fieldNames, localSignUp))