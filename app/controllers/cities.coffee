module.exports = (app) ->
  index: (req, res, next) ->
    app.models.city.find().exec (err, cities) ->
      if err || !cities
        next err
      res.render 'cities/index', cities: cities

  new: (req, res) ->
    res.render 'cities/new'

  create: (req, res, next) ->
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
    app.models.city
    .findOneById(req.params.id)
#    .update(req.params.id, name: req.body.name)
    .exec (err, city) ->
      if err || !city
        next err
      else
        city.name = req.body.name if req.body.name?

        city.save (err, city) ->
          if err ||!city
            next err
          else
            req.flash 'success', "City #{city.name} was updated"
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
