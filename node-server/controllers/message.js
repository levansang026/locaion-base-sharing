var mongoose = require('mongoose');
var Message = require('../models/message');
var admin = require("firebase-admin");
var serviceAccount = require("../abc.json");

admin.initializeApp({
   credential: admin.credential.cert(serviceAccount),
   databaseURL: "https://test-firebase-admin-7ad1f.firebaseio.com"
});

admin.database.enableLogging(true);
var db = admin.database();

   exports.findAll = function(request, response, next){
      Message.find(function(error, messages){
      // In case of any error, forward request to error handler.
      if (error) {
          next();
      }

      // List of all records from db.
      response.json(messages.map(function(message){
          return {
            id: message._id,
            sender: message.sender,
            receiver: message.receiver,
            title: message.title,
            lat_location: message.lat_location,
            long_location: message.long_location,
            content: message.content,
            create_date: message.create_date
          }
          }));
      });
  };

  exports.findByID = function(request, response, next){
    console.log(request.query.id);
      Message.findById(request.query.id, function(error, message){
          if (message != null)
          {
            console.log(request.query.id);
              //render the content.
              response.json({
                id: message._id,
                sender: message.sender,
                receiver: message.receiver,
                title: message.title,
                lat_location: message.lat_location,
                long_location: message.long_location,
                content: message.content,
                create_date: message.create_date
              });
          }
          // In case of any error, forward request to error handler.
          else {
              next();
          }
      });
  };

  exports.add = function(request, response, next){
      // Complete request body.
      var requestBody = request.body;

      // Prepare new data.
      var message = new Message({
        sender: requestBody.sender,
        receiver: requestBody.receiver,
        title: requestBody.title,
        lat_location: requestBody.lat_location,
        long_location: requestBody.long_location,
        content: requestBody.content
      });

      message.save(function(error, message){
          // In case of any error, forward request to error handler.
          if (error) {
              next();
          }

          //post esstencial data to firebase
          var messagesRef = db.ref("messages");
          messagesRef.child(message._id).set({
            sender: message.sender,
            lat_location: message.lat_location,
            long_location: message.long_location
          });

          // Return ID of element in response.
          response.json({id: message._id});
          // Prepare status code 200 and close the response.
          response.status(200).end();
      });
  };

  exports.update = function(request, response, next){
  // Complete request body.
  var requestBody = request.body;
  // Find particular message by ID.
  Message.findById(request.params.id,function(error, message){
      // If the ID is successfully found (message is not null), assign the request attributes to object.
      if (message != null) {

          message.sender = requestBody.sender;
          message.receiver = requestBody.receiver;
          message.title = requestBody.title;
          message.lat_location = requestBody.lat_location;
          message.long_location = requestBody.long_location;
          message.content = requestBody.content;

          message.save(function(error, message){
              if (error) {
              // In case of an issue forward the response to ERROR handles.
                  next();
              }
              // Return ID of element in response.
              response.json({id: message._id});
              // Element successfuly updated. Prepare status code 200 and close the response.
              response.status(200).end();
          });
      }
      else {
      // In case of an issue forward the response to ERROR handles.
      next();
      }
   });
  };

  exports.delete =  function(request, response, next){
  // Find particular message by Id.
  Message.findById(request.params.id,function(error, message){
      if (message != null) {
          message.remove(function(error){
              if (error) {
                  // In case of an issue forward the response to ERROR handles.
                  next();
              }
              response.json({id: message._id});
              // Element successfuly updated.
              response.status(200).end();
          })}
          else {
              // In case of an issue forward the response to ERROR handles.
              next();
          }
      });
  };
