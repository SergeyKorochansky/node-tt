express = require 'express'
app = express()

app.use('/public', express.static(__dirname + '/public'))

app.get '/', (req, res) ->
  res.send 'Hello World!'
  console.log 'GET /'

port = process.env.PORT || 3000

app.listen(port)
