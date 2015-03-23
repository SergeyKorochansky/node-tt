acl = require '../../config/acl'

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

  readAction: (req, res, next) ->
    req.action = 'read'
    req.resource = req.params.resource
    next()

  createAction: (req, res, next) ->
    req.action = 'create'
    req.resource = req.params.resource
    next()

  updateAction: (req, res, next) ->
    req.action = 'update'
    req.resource = req.params.resource
    next()

  destroyAction: (req, res, next) ->
    req.action = 'destroy'
    req.resource = req.params.resource
    next()

  checkAccess:  (req, res, next) ->
    rules = acl[req.user.role.name]
    currentResource = req.resource
    currentAction = req.action

    allowedActions = rule.permissions for rule in rules when currentResource in rule.resources
    if allowedActions? && currentAction in allowedActions
      next()
    else
      next code: 403
