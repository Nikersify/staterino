redis = require 'redis'
config = require '../config'

client = redis.createClient config.redis.port, config.redis.host
client.select config.redis.db

client.on 'connect', ->
	console.log "Connected to redis at #{config.redis.host}:#{config.redis.port} (#{config.redis.db})"

module.exports = client