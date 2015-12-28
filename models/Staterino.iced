db = require '../core/database'

class module.exports
	@genToken: (owner, callback) ->
		token = require('crypto').randomBytes(8).toString('hex')

		await db.hexists 'staterino:tokens', token, defer err, exists
		if exists == 1 # key already exists, just in case
			return @genToken(owner, callback)
		
		await db.hset 'staterino:tokens', token, owner, defer err, reply
		callback? err, token

	@getTokenOwner: (token, callback) ->
		await db.hget 'staterino:tokens', token, defer err, owner
		callback? err, owner