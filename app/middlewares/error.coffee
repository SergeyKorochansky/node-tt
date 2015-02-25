module.exports =
  notFound: (req, res) ->
    res.status 404
    res.render 'error/404', url: req.url

  internalError: (err, req, res, next) ->
    res.status 500
    res.render 'error/500'
