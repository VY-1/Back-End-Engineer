/*
Sending A Response
HTTP follows a one request-one response cycle. Each client expects exactly one response per request, and each server should only send a single response back to the client per request. The client is like a customer at a restaurant ordering a large bowl of soup: the request is sent through the wait staff, the kitchen prepares the soup, and after it is prepared, the wait staff returns it to the customer. In the restaurant, it would be unfortunate if the soup never arrived back to the customer, but it would be equally problematic if the customer was given four large bowls of soup and was asked to consume them all at the exact same time. That’s impossible with only two hands!

Express servers send responses using the .send() method on the response object. .send() will take any input and include it in the response body.

const monsters = [
  { type: 'werewolf' }, 
  { type: 'hydra' }, 
  { type: 'chupacabra' }
];
app.get('/monsters', (req, res, next) => {
  res.send(monsters);
});

In this example, a GET /monsters request will match the route, Express will call the callback function, and the res.send() method will send back an array of spooky monsters.

In addition to .send(), .json() can be used to explicitly send JSON-formatted responses. .json() sends any JavaScript object passed into it.
*/

const express = require("express");
const app = express();
const { seedElements } = require("./utils");

// Serves Express Yourself website
app.use(express.static("public"));

const PORT = process.env.PORT || 4001;

const expressions = [];
seedElements(expressions, "expressions");

// Get all expressions
app.get("/expressions", (req, res, next)=>{
    res.json(expressions);
});


app.listen(PORT, () => {
    console.log(`Listening on port ${PORT}`);
});
  