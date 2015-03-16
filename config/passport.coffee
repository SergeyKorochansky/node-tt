LocalStrategy = require('passport-local').Strategy

module.exports = (userModel, passport) ->
  serialize = (user, done) ->
    done(null, user.id)

  deserialize = (id, done) ->
    userModel.findOne id: id, (err, user) ->
      done(err, user)


  passport.serializeUser(serialize)
  passport.deserializeUser(deserialize)

  loginParams =
    usernameField: 'email'

  signupParams =
    usernameField: 'email'
    passReqToCallback: true

  localLogin = (email, password, done) ->
    userModel
      .findOneByEmail(email.toLowerCase())
      .then (user) ->
        user.comparePasswords password, (err, matched) ->
          if matched
            done(null, user)
          else
            done(null, false, message: 'Invalid credentials')
      .catch ->
        done(null, false, message: 'Invalid credentials')


  passport.use('local-login', new LocalStrategy(loginParams, localLogin))

  localSignUp = (req, email, password, done) ->
    userModel
      .create
        email: email.toLowerCase()
        password: password
        firstName: req.body.firstName
        lastName: req.body.lastName
      .then (user) ->
          done(null, user)
      .catch (err) ->
        invalidFields = err.keys.join(' ')
        done(null, false, message: "This fields are incorrect: #{invalidFields}")

  passport.use('local-signup', new LocalStrategy(signupParams, localSignUp))