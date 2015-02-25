module.exports =
  new: (req, res) ->
    res.render('sessions/new')

  create: (passport) ->
    do ->
      passport.authenticate 'local-login',
        successRedirect: '/'
        failureRedirect: 'back'
        successFlash: 'You have successfully logged in!'
        failureFlash: true

  destroy: (req, res) ->
    req.logout()
    req.flash 'info', 'You have successfully logged out!'
    res.redirect '/login'
