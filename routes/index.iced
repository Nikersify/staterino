express = require 'express'
router = express.Router()

router.use '/auth', require './auth'
router.use '/dashboard', require './dashboard'
router.use '/endpoint', require './endpoint'

router.get '/error', (req, res) ->
	res.render 'error'

router.get '/', (req, res) ->
	res.render 'index', user: req.user

module.exports = router