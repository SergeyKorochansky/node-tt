module.exports = ->
  new: (req, res) ->
    res.render 'users/new'

  create: (passport) ->
    passport.authenticate 'local-signup',
      successRedirect: '/'
      failureRedirect: 'back'
      failureFlash: true