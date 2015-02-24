module.exports =
  isLoggedIn: (req, res, next) ->
    if req.user
      next()
    else
      req.flash 'error', 'You must be logged in!'
      res.redirect '/login'

  isNotLoggedIn: (req, res, next) ->
    if req.user
      req.flash 'error', 'You are already logged in!'
      res.redirect '/'
    else
      next()