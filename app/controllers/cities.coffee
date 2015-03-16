module.exports = (app) ->
#  TODO Move this check to model's lifecycle callback
  checkCityForUniqueness = (req, res, cb) ->
    app.models.city.
    findOneByName(req.body.name).
    exec (err, nonUniqueCity) ->
      if nonUniqueCity
        req.flash 'error', 'City with same name already exists'
        res.redirect 'back'
      else
        cb()

  index: (req, res, next) ->
    app.models.city.find().exec (err, cities) ->
      if err || !cities
        next err
      res.render 'cities/index', cities: cities

  new: (req, res) ->
    res.render 'cities/new'

  create: (req, res, next) ->
    checkCityForUniqueness req, res, ->
      app.models.city
      .create(name: req.body.name)
      .exec (err, city) ->
        if err || !city
          next err
        else
          req.flash 'success', "City #{city.name} was created"
          res.redirect '/cities'

  edit: (req, res, next) ->
    app.models.city
    .findOneById(req.params.id)
    .exec (err, city) ->
      if err || !city
        next err
      else
        res.render 'cities/edit', city: city

  update: (req, res, next) ->
    checkCityForUniqueness req, res, ->
      app.models.city
      .update(req.params.id, name: req.body.name)
      .exec (err, cities) ->
        if err || !cities
          next err
        else
          req.flash 'success', "City #{cities[0].name} was updated"
          res.redirect '/cities'

  destroy: (req, res, next) ->
    app.models.city
    .destroy(req.params.id)
    .exec (err, cities) ->
      if err || !cities
        next err
      else
        req.flash 'success', "City #{cities[0].name} was deleted"
        res.redirect '/cities'
