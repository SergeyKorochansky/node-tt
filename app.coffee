app = require('express')()

app.get '/', (req, res) ->
  res.send 'Hello World!'
  console.log 'GET /'

app.listen(3000)
