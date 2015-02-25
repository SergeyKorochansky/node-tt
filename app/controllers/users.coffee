module.exports =
  new: (req, res) ->
    res.render 'users/new'
  create: (passport) ->
    do ->
      passport.authenticate 'local-signup',
        successRedirect: '/'
        failureRedirect: 'back'
        failureFlash: true

  restore: (req, res) ->
    res.render 'users/restore'
  reset: (req, res) ->
    # reset password
    req.flash 'New password was send to your email'
    res.redirect '/login'
