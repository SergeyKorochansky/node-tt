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
    app.models.user
    .findOneById(req.params.id)
    .exec (err, user) ->
      if err || !user
        next err
      else
        attributes = {}
        attributes.email = req.body.email.toLowerCase() if req.body.email
        attributes.password = req.body.password if req.body.password
        attributes.firstName = req.body.firstName if req.body.firstName
        attributes.lastName = req.body.lastName if req.body.lastName
        attributes.city = req.body.city if req.body.city

        app.models.user
        .update(req.params.id, attributes)
        .exec (err, users) ->
          if err || !users
            next err
          else
            req.flash 'success', 'User\'s information was successful updated'
            res.redirect '/'

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