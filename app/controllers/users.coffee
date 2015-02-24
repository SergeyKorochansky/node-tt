module.exports =
  new: (req, res) ->
    res.render 'users/new'
  create: (passport) ->
    (req, res) ->
  restore: (req, res) ->
    res.render 'users/restore'
  reset: (req, res) ->
    # reset password
    req.flash 'New password was send to your email'
    res.redirect '/login'
