module.exports = (app) ->
  index: (req, res, next) ->
    app.models.project
    .find()
    .exec (err, projects) ->
      if err || !projects
        next err
      else
        res.render 'projects/index', projects: projects
  new: (req, res) ->
    res.render 'projects/new'

  create: (req, res, next) ->
    app.models.project
    .create
      name: req.body.name
      description: req.body.description
#      users: req.user.id
    .exec (err, project) ->
      if err || !project
        next err
      else
        project.users.add req.user

        project.save (err, project) ->
          if err || !project
            next err
          else
            req.flash 'success', "Project #{project.name} was created"
            res.redirect "/projects/#{project.id}"

  show: (req, res, next) ->
    app.models.project
    .findOneById(req.params.id)
    .populate('users')
    .populate('milestones')
    .exec (err, project) ->
      if err || !project
        next err
      else
        res.render 'projects/show', project: project

  edit: (req, res, next) ->
    app.models.project
    .findOneById(req.params.id)
    .exec (err, project) ->
      if err || !project
        next err
      else
        res.render 'projects/edit', project: project

  update: (req, res, next) ->
    app.models.project
    .findOneById(req.params.id)
    .exec (err, project) ->
      if err || !project
        next err
      else
        project.name = req.body.name if req.body.name?
        project.description = req.body.description if req.body.description?

        project.save (err, project) ->
          if err ||!project
            next err
          else
            req.flash 'success', "Project #{project.name} was updated"
            res.redirect "/projects/#{project.id}"

  destroy: (req, res, next) ->
    app.models.project
    .destroy(req.params.id)
    .exec (err, projects) ->
      if err || !projects
        next err
      else
        req.flash 'success', "Project #{projects[0].name} was deleted"
        res.redirect '/projects'
