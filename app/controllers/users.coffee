module.exports = (app) ->
  index: (req, res, next) ->
    app.models.user
    .find()
    .populate('city')
    .exec (err, users) ->
      if err || !users
        next err
      else
        res.render 'users/index', users: users

  new: (req, res) ->
    res.render 'users/new'

  create: (passport) ->
    passport.authenticate 'local-signup',
      successRedirect: '/'
      failureRedirect: 'back'
      failureFlash: true

# TODO Allow only role changing
  update: (req, res, next) ->
    next req, res

  destroy: (req, res, next) ->
    app.models.user
    .destroy(req.params.id)
    .exec (err, users) ->
      if err || !users
        next err
      else
        if req.user.id == req.params.id
          req.logout()
          req.flash 'success', 'Your account was deleted'
          res.redirect '/login'
        else
          req.flash 'success', "User #{users[0].fullName()} was deleted"
          res.redirect '/users'