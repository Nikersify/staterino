config = require '../config'
express = require 'express'
moment = require 'moment'
passport = require 'passport'
router = express.Router()
TwitchStrategy = require('passport-twitch').Strategy
User = require '../models/User'

passport.use new TwitchStrategy
	clientID: config.twitch.client_id
	clientSecret: config.twitch.client_secret
	callbackURL: 'http://localhost:3000/auth/return'
	scope: 'user_read'
	, (accessToken, refreshToken, profile, done) ->
		now = moment().unix()

		data = profile._json

		data.accessToken = accessToken
		data.refreshToken = refreshToken
		data.lastLogin = now
		data.id = data._id
		data.updated_at = moment(data.updated_at).unix()
		data.created_at = moment(data.created_at).unix()
		# i've heard that delete is INSANELY SLOW, but unfortunately
		# i can't be bothered to care at the moment :^)

		delete data._id
		delete data.notifications
		delete data._links
		delete data.username
		delete data.type

		user = new User data.username
		
		await user.exists defer err, exists
		if not exists
			# todo default settings
			data.signedUp = now
		
		await user.setAll data, defer err, reply 
		
		await user.getAll defer err, all

		done err, all


passport.serializeUser (user, done) ->
	# todo: serialize user in a cookie to an id
	done null, user

passport.deserializeUser (user, done) ->
	# todo: deserialize user from a cookie from an id
	# this is stuff sent to req.user
	done null, user

router.get '/return', passport.authenticate('twitch', failureRedirect: '/error'), (req, res) ->
	res.redirect '/'

router.get '/login', passport.authenticate 'twitch'

router.get '/logout', (req, res) ->
	req.logout()
	res.redirect '/'


module.exports = router