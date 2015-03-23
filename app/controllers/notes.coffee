module.exports = (app) ->
  new: (req, res, next) ->
    app.models.milestone
    .findOneById(req.query.milestone)
    .exec (err, milestone) ->
      if err || !milestone
        next err
      else
        res.render 'notes/new', milestone: milestone

  create: (req, res, next) ->
    options =
      name: req.body.name
      user: req.user.id
      milestone: req.body.milestone
    options.content = req.body.content if req.body.content?

    app.models.note
    .create(options)
    .exec (err, note) ->
      if err || !note
        next err
      else
        req.flash 'success', "Note #{note.name} was created"
        res.redirect "/notes/#{note.id}"

  show: (req, res, next) ->
    app.models.note
    .findOneById(req.params.id)
    .populate('user')
    .populate('milestone')
    .exec (err, note) ->
      if err || !note
        next err
      else
        res.render 'notes/show', note: note

  edit: (req, res, next) ->
    app.models.note
    .findOneById(req.params.id)
    .populate('user')
    .populate('milestone')
    .exec (err, note) ->
      if err || !note
        next err
      else
        res.render 'notes/edit', note: note

  update: (req, res, next) ->
    app.models.note
    .findOneById(req.params.id)
    .exec (err, note) ->
      if err || !note
        next err
      else
        note.name = req.body.name if req.body.name?
        note.content = req.body.content if req.body.content?

        note.save (err, note) ->
          if err || !note
            next err
          else
            req.flash 'success', "Note #{note.name} was updated"
            res.redirect "/notes/#{note.id}"

  destroy: (req, res, next) ->
    app.models.note
    .destroy(req.params.id)
    .exec (err, notes) ->
      if err || !notes
        next err
      else
        req.flash 'success', "Note #{notes[0].name} was deleted"
        res.redirect "/milestones/#{notes[0].milestone}"
