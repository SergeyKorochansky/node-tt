module.exports =
  notFound: (req, res) ->
    res.status 404
    res.render 'error/404', url: req.url

  forbidden: (err, req, res, next) ->
    if err.code == 403
      res.status 403
      res.render 'error/403', method: req.method, url: req.url
    else
      next err

  validationError: (err, req, res, next) ->
    if err.code == 'E_VALIDATION'
      keys = Object.keys(err.invalidAttributes).join ', '
      req.flash 'error', "#{err.reason}: #{keys}"
      res.redirect 'back'
    else
      next err

  internalError: (err, req, res) ->
    res.status 500
    res.render 'error/500'
