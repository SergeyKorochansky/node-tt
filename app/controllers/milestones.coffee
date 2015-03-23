module.exports = (app) ->
  new: (req, res, next) ->
    app.models.project
    .findOneById(req.query.project)
    .exec (err, project) ->
      if err || !project
        next err
      else
        res.render 'milestones/new', project: project

  create: (req, res, next) ->
    app.models.milestone
    .create
        name: req.body.name
        complete: req.body.complete if req.body.complete?
        number: req.body.number if req.body.number?
        project: req.body.project
    .exec (err, milestone) ->
      if err || !milestone
        next err
      else
        req.flash 'success', "Milestone #{milestone.name} was created"
        res.redirect "/milestones/#{milestone.id}"

  show: (req, res, next) ->
    app.models.milestone
    .findOneById(req.params.id)
    .populate('project')
    .populate('notes', sort: 'updatedAt desc')
    .exec (err, milestone) ->
      if err || !milestone
        next err
      else
        res.render 'milestones/show', milestone: milestone

  edit: (req, res, next) ->
    app.models.milestone
    .findOneById(req.params.id)
    .populate('project')
    .exec (err, milestone) ->
      if err || !milestone
        next err
      else
        res.render 'milestones/edit', milestone: milestone

  update: (req, res, next) ->
    app.models.milestone
    .findOneById(req.params.id)
    .exec (err, milestone) ->
      if err || !milestone
        next err
      else
        milestone.name = req.body.name if req.body.name?
        milestone.complete = req.body.complete if req.body.complete?
        milestone.number = req.body.number if req.body.number?

        milestone.save (err, milestone) ->
          if err ||!milestone
            next err
          else
            req.flash 'success', "Milestone #{milestone.name} was updated"
            res.redirect "/milestones/#{milestone.id}"

  destroy: (req, res, next) ->
    app.models.milestone
    .destroy(req.params.id)
    .exec (err, milestones) ->
      if err || !milestones
        next err
      else
        req.flash 'success', "Milestone #{milestones[0].name} was deleted"
        res.redirect "/projects/#{milestones[0].project}"
