db = require '../core/database'

class module.exports
	
	constructor: (@twitch_id) ->

	exists: (callback) ->
		await db.exists 'user:' + @twitch_id, defer err, reply
		callback? err, reply

	setAll: (data, callback) ->
		await db.hmset 'user:' + @twitch_id, data, defer err, reply
		callback? err, reply

	getAll: (callback) ->
		await db.hgetall 'user:' + @twitch_id, defer err, reply
		callback? err, reply