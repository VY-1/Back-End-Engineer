// app.param() Method Demo Example

// Importing the express module
const express = require('express');

// Initializing the express and port number
var app = express();
// Initializing the router from express
var router = express.Router();
var PORT = 3000;

app.param('id', function (req, res, next, id) {
   console.log('app.param is called');
   req.params;
   console.log(`id = ${id}`);
   next();
});

app.get('/api/:id', function (req, res, next) {
   console.log('Welcome to Tutorials Point!');
   next();
});

app.get('/api/:id', function (req, res) {
   console.log('SIMPLY LEARNING');
   res.end();
});

// App listening on the below port
app.listen(PORT, function(err){
   if (err) console.log(err);
   console.log("Server listening on PORT", PORT);
});