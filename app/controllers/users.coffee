module.exports =
  new: (req, res) ->
    res.render 'users/new'

  create: (passport) ->
    do ->
      passport.authenticate 'local-signup',
        successRedirect: '/'
        failureRedirect: 'back'
        failureFlash: true