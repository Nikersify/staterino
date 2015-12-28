User = require('../models/User')

module.exports = (realms) -> # realm is array
	(req, res, next) ->
		if req.user
			user = new User req.user.name
			if typeof realms == 'string'
				await user.getAll realms, defer err, reply
				if err
					return next err
				req.user[realms] = reply
			
			else if typeof realms == 'object' # array
				for realm in realms
					await user.getAll realm, defer err, reply
					if err
						return next err
					req.user[realm] = reply
		
		next null