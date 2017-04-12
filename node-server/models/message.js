'use strict';

const mongoose = require("mongoose");
var autoIncrement = require('mongoose-auto-increment');

var opts = {
        server: {
        socketOptions: {keepAlive: 1}
    }
};

mongoose.Promise = require('bluebird'); 
const connectionString = 'mongodb://localhost/test-message';
var connection = mongoose.connect(connectionString, opts);

autoIncrement.initialize(connection);

var MessageSchema = new mongoose.Schema({
  sender: {type: String, default: "unknow"},
  receiver: {type: String, default: "public"},
  title: {type: String},
  lat_location: {type: Number},
  long_location: {type: Number},
  content: {type: String},
  create_date: {type: Date, default: Date.now}
});

MessageSchema.plugin(autoIncrement.plugin, 'Message');

var Message = mongoose.model('Message', MessageSchema);

Message.find(function(error, messages){
  if (messages.length) {
      return;
  }

  new Message({
    title: "Message from KHTN",
    lat_location: 10.7630175,
    long_location: 106.6804122,
    content: "Wellcome to university of science"
  }).save();

  new Message({
    title: "How about you?",
    lat_location: 10.7744604,
    long_location: 106.701099,
    content: "Wellcome to university of science"
  }).save();

  new Message({
    title: "Hi, Mr.Dao",
    lat_location: 10.7247317,
    long_location: 106.7162994,
    content: "You and me have been there. You are handsome"
  }).save();
});

module.exports = Message;
