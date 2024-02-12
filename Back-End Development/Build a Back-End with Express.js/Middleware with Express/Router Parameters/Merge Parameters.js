/*
Merge Parameters
Complexity is all
Complexity is all around us. Buildings are made from bricks and many droplets of water make a cloud. When we want to create something complex in software, we model out our base components and use composition to create these relationships.

When we’re building web endpoints, we might want to access some property of a complex object. In order to do this in Express, we can design a nested router. This would be a router that is invoked within another router. In order to pass parameters the parent router has access to, we pass a special configuration object when defining the router.

const sorcererRouter = express.Router();
const familiarRouter = express.Router({mergeParams: true});

sorcererRouter.use('/:sorcererId/familiars', familiarRouter);

sorcererRouter.get('/', (req, res, next) => {
  res.status(200).send(Sorcerers);
  next();
});

sorcererRouter.param('sorcererId', (req, res, next, id) => {
  const sorcerer = getSorcererById(id);   
  req.sorcerer = sorcerer;
  next();
});

familiarRouter.get('/', (req, res, next) => {
  res.status(200).send(`Sorcerer ${req.sorcerer} has familiars ${getFamiliars(sorcerer)}`);
});

app.use('/sorcerer', sorcererRouter);

In the code above we define two endpoints: /sorcerer and /sorcerer/:sorcererId/familiars. The familiars are nested into the sorcerer endpoint — indicating the relationship that a sorcerer has multiple familiars. Take careful note of the {mergeParameters: true} argument that gets passed when creating the familiarRouter. This argument tells Express that the familiarRouter should have access to parameters passed into its parent router, that is, the sorcererRouter. We then tell express that the path for the familiarRouter is the same as the path for the sorcererRouter with the additional path /:sorcererId/familiars. We then can create a family of routes (a router) built by appending routes to familiarRouter‘s base: /sorcerer/:sorcererId/familiars.
*/

const express = require("express");
const app = express();
const bodyParser = require("body-parser");

app.use(express.static("public"));

const PORT = process.env.PORT || 4001;

app.use(bodyParser.json());

const spiceRacks = [
    {
      id: 1,
      location: 'Kitchen Countertop',
    },
    {
      id: 2,
      location: 'Pantry',
    },
    {
      id: 3,
      location: 'Outdoor Barbecue',
    }
  ];

let nextSpiceRackId = 4;

app.param("spiceRackId", (req, res, next, id)=>{
    //convert id to Number using the Number function
    const idToFind = Number(id);
    //gets index of the spiceRack based on id
    const rackIndex = spiceRacks.findIndex(spiceRack => spiceRack.id === idToFind);
    //if index not equal to -1. Or if exist
    if(rackIndex !== -1){
        //assign req.spiceRack to the found spice
        req.spiceRack = spiceRacks[rackIndex];
        req.spiceRackIndex = rackIndex;
        //call next() to move on request method that contains spiceRackId parameter that the user requests
        next();
    }
    else{
        //set response status to 404 and send "Spice Rack Not Found." if rackIndex returns -1
        res.status(404).send("Spice Rack Not Found.");
    }
});

app.get("/spice-racks/", (req, res, next)=>{
    res.send(spiceRacks);
});

app.post("/spice-racks/", (req, res, next)=>{
    const newRack = req.body.spiceRack;
    //assign newRack.id = to the current nextSpiceRackId and increment by 1;
    newRack.id = nextSpiceRackId ++;
    //push it to the spiceRacks list
    spiceRacks.push(newRack);
    //sends response with of the newRack object
    res.send(newRack);

});

app.get("/spice-racks/:spiceRackId", (req, res, next)=>{
    res.send(req.spiceRack);
});

app.put("/spice-racks/:spiceRackId", (req, res, next)=>{
    //sets the requested spiceRack object and assight it to the updatedRack variable
    const updatedRack = req.body.spiceRack;
    // if the req.spiceRack.id not equal to the updatedRack.id response with error status 400
    if(req.spiceRack.id !== updatedRack.id){
        res.status(400).send("Cannot update Spice Rack Id");
    }else {
        //else update the spiceRacks at indext to the new updatedRack object
        spiceRacks[req.spiceRackIndex] = updatedRack;
        res.send(spiceRacks[req.spiceRackIndex]);
    }
});


app.delete('/spice-racks/:spiceRackId', (req, res, next) => {
    spiceRacks.splice(req.spiceRackIndex, 1);
    res.status(204).send();
  });
  
  const spicesRouter = require('./spicesRouter.js');
  
  // Write your code below:
  app.use("/spice-racks/:spiceRackId/spices", spicesRouter);
  
  
  
  app.listen(PORT, () => {
    console.log(`Server is listening on port ${PORT}`);
  });