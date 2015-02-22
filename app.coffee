express = require 'express'
morgan = require 'morgan'
app = express()

app.use('/public', express.static(__dirname + '/public'))
app.use(morgan('dev'))
app.set('view engine', 'jade')

app.get '/', (req, res) ->
  res.send 'Hello World!'

port = process.env.PORT || 3000

app.listen(port)

console.log('Listening on port %s', port)