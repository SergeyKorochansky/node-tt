LocalStrategy = require('passport-local').Strategy

module.exports = (userModel, passport) ->
  serialize = (user, done) ->
    done(null, user.id)

  deserialize = (id, done) ->
    userModel
    .findOneById(id)
    .populate('role')
    .exec (err, user) ->
      done(err, user)

  passport.serializeUser(serialize)
  passport.deserializeUser(deserialize)

  loginParams =
    usernameField: 'email'

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

  signupParams =
    usernameField: 'email'
    passReqToCallback: true

  localSignUp = (req, email, password, done) ->
    userModel
    .create
      email: email.toLowerCase()
      password: password
      firstName: req.body.firstName
      lastName: req.body.lastName
      city: req.body.city
    .exec (err, user) ->
        done(err, user)

  passport.use('local-signup', new LocalStrategy(signupParams, localSignUp))