db = require '../core/database'

class module.exports
	
	constructor: (@name) ->

	exists: (callback) ->
		await db.exists 'user:' + @name + ':basic', defer err, reply
		callback? err, reply

	setAll: (realm, data, callback) ->
		await db.hmset "user:#{@name}:#{realm}", data, defer err, reply
		callback? err, reply

	getAll: (realm, callback) ->
		await db.hgetall "user:#{@name}:#{realm}", defer err, reply
		callback? err, reply