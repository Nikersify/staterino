config = require '../config'
express = require 'express'
moment = require 'moment'
passport = require 'passport'
router = express.Router()
TwitchStrategy = require('passport-twitch').Strategy
User = require '../models/User'
Staterino = require '../models/Staterino'

passport.use new TwitchStrategy
	clientID: config.twitch.client_id
	clientSecret: config.twitch.client_secret
	callbackURL: 'http://localhost:3000/auth/return'
	scope: 'user_read'
	force_verify: 'true'
	, (accessToken, refreshToken, profile, done) ->
		now = moment().unix()
		
		basic = profile._json

		basic.provider = 'twitch'
		basic.accessToken = accessToken
		basic.refreshToken = refreshToken
		basic.staterino_lastLogin = now
		basic.id = basic._id
		basic.updated_at = moment(basic.updated_at).unix()
		basic.created_at = moment(basic.created_at).unix()
		
		# i've heard that delete is INSANELY SLOW, but unfortunately
		# i can't be bothered to care at the moment :^)

		delete basic._id
		delete basic.notifications
		delete basic._links
		delete basic.username
		delete basic.type

		user = new User basic.name
		
		await user.exists defer err, exists

		if not exists
			# default settings
			basic.staterino_joined = now
			
			await Staterino.genToken basic.name, defer err, token
			
			auth =
				token: token
				revoked: now
			
			await user.setAll 'auth', auth, defer err, reply

		await user.setAll 'basic', basic, defer err, reply 

		await user.getAll 'basic', defer err, all
		done err, all


passport.serializeUser (user, done) ->
	done null, user.name

passport.deserializeUser (name, done) ->
	# stuff sent to req.user
	# we always send basic because it's useful
	user = new User(name)
	await user.getAll 'basic', defer err, reply
	done err, reply

router.get '/return', passport.authenticate('twitch', failureRedirect: '/error'), (req, res) ->
	res.redirect '/'

router.get '/login', passport.authenticate 'twitch'

router.get '/logout', (req, res) ->
	req.logout()
	res.redirect '/'


module.exports = router