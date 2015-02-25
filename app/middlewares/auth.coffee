module.exports =
  isLoggedIn: (req, res, next) ->
    if req.isAuthenticated()
      next()
    else
      req.flash 'error', 'You must be logged in!'
      res.redirect '/login'

  isNotLoggedIn: (req, res, next) ->
    if req.isAuthenticated()
      req.flash 'error', 'You are already logged in!'
      res.redirect '/'
    else
      next()

  setLocals: (req, res, next) ->
    res.locals.user = req.user
    next()