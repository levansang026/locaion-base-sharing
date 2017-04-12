var passport = require('passport');
var LocalStrategy = require('passport-local').Strategy;
var FacebookStrategy = require('passport-facebook').Strategy;
var mongoose = require('mongoose');
var User = require('../models/user');
var configAuth = require('./auth');

// used to serialize the user for the session
  passport.serializeUser(function(user, done) {
      done(null, user.id);
  });

  // used to deserialize the user
  passport.deserializeUser(function(id, done) {
      User.findById(id, function(err, user) {
          done(err, user);
      });
  });

passport.use(new LocalStrategy({
    usernameField: 'email'
  },
  function(username, password, done) {
    User.findOne({ email: username }, function (err, user) {
      if (err) { return done(err); }
      // Return if user not found in database
      if (!user) {
        return done(null, false, {
          message: 'User not found'
        });
      }
      // Return if password is wrong
      if (!user.validPassword(password)) {
        return done(null, false, {
          message: 'Password is wrong'
        });
      }
      // If credentials are correct, return the user object
      return done(null, user);
    });
  }
));

passport.use(new FacebookStrategy({
        clientID        : configAuth.facebookAuth.clientID,
        clientSecret    : configAuth.facebookAuth.clientSecret,
        callbackURL     : configAuth.facebookAuth.callbackURL
      },

      function(token, refreshToken, profile, done){
        process.nextTick(function(){
          User.findOne({'facebook.id': profile.id}, function(error, user){
            if (err)
                  return done(err);

              // if the user is found, then log them in
              if (user) {
                  return done(null, user); // user found, return that user
              } else {
                var user = new User();

                user._id = profile.id;
                user.hash = token; //if not local Strategy use hash for token
                user.name = profile.name.givenName + ' ' + profile.name.familyName;
                user.email = profile.emails[0].value;

                console.log(user._id);
                // save our user to the database
                  user.save(function(err) {
                      if (err)
                          throw err;

                      // if successful, return the new user
                      return done(null, user);
                  });
              }
          });
        });
      }
));
