var http = require('http');
var bodyParser = require('body-parser');
var mongoose = require('mongoose');
var autoIncrement = require('mongoose-auto-increment');
var express = require('express');
var passport = require('passport');


// Initialize app by using Express framework.
var app = express();

// Use Body Parser (Helps to process incoming requests).

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

app.set('port', process.env.PORT || 3000);

require('./config/passport');

var messageRouter = require('./routers');
var authRouter = require('./routers/auth_routers');

app.use(passport.initialize());

app.use('/',messageRouter);
app.use('/auth_api/', authRouter);

// Use Express midleware to handle 404 and 500 error states.
app.use(function(request, response){
    // Set status 404 if none of above routes processed incoming request.
    response.status(404);
    // Generate the output.
    response.send('404 - not found');
});

// 500 error handling. This will be handled in case of any internal issue on the host side.
app.use(function(request, response){
  // Set response type to application/json.
  response.type('application/json');
  // Set response status to 500 (error code for internal server error).
  response.status(500);
  // Generate the output - an Internal server error message.
  response.send('500 - internal server error');

});


// Start listening on defined port, this keep running the application until hit Ctrl + C key combination.
app.listen(app.get('port'), function(){
    console.log("Host is running and listening on http://localhost:" + app.get('port') + '; press Ctrl-C to terminate.');
});
