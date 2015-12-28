express = require 'express'
router = express.Router()
Staterino = require '../models/Staterino'

io = require('../core/socket').io

router.post '/', (req, res) ->
	await Staterino.getTokenOwner req.body.auth.token, defer err, owner
	console.log(owner)
	res.end()

module.exports = router