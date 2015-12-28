module.exports =
	startSocketServer: (server) ->
		module.exports.io = require('socket.io')(server)