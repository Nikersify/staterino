express = require 'express'
router = express.Router()

router.get '/', (req, res) ->
	res.end('no elo')

module.exports = router