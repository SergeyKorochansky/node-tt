module.exports =
  new: (req, res) ->
    res.render('sessions/new')
  create: (req, res) ->
    res.send('2')
  destroy: (req, res) ->
    res.send('3')

