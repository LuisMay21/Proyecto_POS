'use strict';

var express = require('express');
var bodyParser = require('body-parser');
var usersRoute = require('./routes/usersRoute');

var app = express();

// create application/json parser
var jsonParser = bodyParser.json();
// create application/x-www-form-urlencoded parser
var urlencodedParser = bodyParser.urlencoded({ extended: false });

// middleware para parsear el body
app.use(jsonParser);
app.use(urlencodedParser);

// set up routes
app.use('/users', usersRoute);

// start server
var port = 3000;
app.listen(port, function () {
    console.log('Server running on port ' + port);
});