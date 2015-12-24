express = require 'express'
router = express.Router()

router.use '/auth', require './auth'
router.use '/dashboard', require './dashboard'

router.get '/error', (req, res) ->
	res.render 'error'

router.get '/', (req, res) ->
	global.debug = req.user
	res.render 'index', user: req.user

module.exports = router