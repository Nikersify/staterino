express = require 'express'
realm = require '../middleware/realm'
requireAuth = require '../middleware/requireAuth'
router = express.Router()

router.get '/', requireAuth, (req, res) ->
	res.render 'dashboard', user: req.user

module.exports = router