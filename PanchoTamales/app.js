'use strict';

var express = require('express');
var bodyParser = require('body-parser');
var cors = require('cors');
var usersRoute = require('./routes/usersRoute');

var app = express();

// 1. CONFIGURACIÓN DE CORS
// Debe ser el PRIMERO después de las importaciones, antes de body-parser y routes.
var corsOptions = {
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
};
app.use(cors(corsOptions)); // ⬅️ CORS PRIMERO

// 2. MIDDLEWARE DE PARSEO (BODY PARSER)
var jsonParser = bodyParser.json();
var urlencodedParser = bodyParser.urlencoded({ extended: false });
app.use(jsonParser);
app.use(urlencodedParser);

// 3. RUTAS
app.use('/users', usersRoute); // ⬅️ Rutas al FINAL

// start server
var port = 3000;
app.listen(port, function () {
    console.log('Server running on port ' + port);
});