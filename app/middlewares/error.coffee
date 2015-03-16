module.exports =
  notFound: (req, res) ->
    res.status 404
    res.render 'error/404', url: req.url

  validationError: (err, req, res, next) ->
    if err.code == 'E_VALIDATION'
      req.flash 'error', err.reason
      res.redirect 'back'
    else
      next err

  internalError: (err, req, res) ->
    res.status 500
    res.render 'error/500'
