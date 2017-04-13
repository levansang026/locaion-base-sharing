
  var messages = require('./controllers/message');
  const routes = require('express').Router();

  routes.get('/api/messages', messages.findAll);
  routes.get('/api/messages/:id/', messages.findByID);
  routes.put('/api/messages/:id', messages.update);
  routes.post('/api/messages', messages.add);
  routes.delete('/api/messages/:id', messages.delete);

  module.exports = routes;
