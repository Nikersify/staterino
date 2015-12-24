iced = require 'iced-coffee-script'

bodyParser = require 'body-parser'
config = require './config'
express = require 'express'
morgan = require 'morgan'
passport = require 'passport'
repl = require 'repl'
session = require 'express-session'

RedisStore = require('connect-redis')(session)

app = express()

app.set 'view engine', 'jade'

app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()

app.use morgan 'dev'

app.use session
	store: new RedisStore(client: require './core/database')
	secret: config.express.secret
	resave: true
	saveUninitialized: true

app.use passport.initialize()
app.use passport.session()

app.use require './routes'

app.listen config.express.port, ->
	console.log "Express listening on #{config.express.port}"

r = repl.start
	prompt: 'Staterino> '
	useGlobal: true

r.on 'exit', ->
	console.log '\nTerminating...'
	process.exit()