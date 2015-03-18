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
    app.models.city
    .find()
    .sort('name')
    .exec (err, cities) ->
      if err
        next err
      else
        res.render 'users/new', cities: cities

  create: (passport) ->
    passport.authenticate 'local-signup', successRedirect: '/'
      successRedirect: '/'
      failureRedirect: 'back'
      failureFlash: true

  edit: (req, res, next) ->
    app.models.city
    .find()
    .sort('name')
    .exec (err, cities) ->
      if err
        next err
      else
        res.render 'users/edit', cities: cities

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