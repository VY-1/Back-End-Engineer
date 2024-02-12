//creatge router using express and allows merge parmameter
const router = require("express").Router({mergeParams: true});

const spices = [
    {
      id: 1,
      name: 'cardamom',
      grams: 45,
      spiceRackId: 1,
    },
    {
      id: 2,
      name: 'pimentón',
      grams: 20,
      spiceRackId: 1,
    },
    {
      id: 3,
      name: 'cumin',
      grams: 450,
      spiceRackId: 3,
    },
    {
      id: 4,
      name: 'sichuan peppercorns',
      grams: 107,
      spiceRackId: 2,
    }
  ];

let nextSpiceId = 5;

router.param("spiceId", (req, res, next, id)=>{
    const idToFind = Number(id);
    const spiceIndex = spices.findIndex(spice=> spice.id === idToFind);
    if(spiceIndex !== -1){
        req.spice = spices[spiceIndex];
        req.spiceIndex = spiceIndex;
        next();
    }
    else{
        res.status(404).send("Spice Not Found.");
    }
});

router.post("/", (req, res, next)=>{
    const newSpice = req.body.spice;
    if(newSpice.name && newSpice.grams){
        //assign newSpice.id with the current nextSpiceId and increment by 1
        newSpice.id = nextSpiceId++;
        //assign newSpice.spiceRackId to parent router attached durnig mergeParams. Convert to number using Number() method
        newSpice.spiceRackId = Number(req.params.spiceRackId);
        //push the new spice to the spices list
        spices.push(newSpice);
        //set status to 201... new object created. and send the newSpice object
        res.status(201).send(newSpice);
    }
    else{
        //else set status to 400, object not found
        res.status(400).send();
    }
});

router.get("/:spiceId", (req, res, next)=>{
    res.send(spices[spiceIndex]);
});

router.put("/:spiceId", (req, res, next)=>{
    //grab spice object from the requested body object and assigns to updatedSpice var
    const updatedSpice = req.body.spice;
    if(req.spice.id !== updatedSpice.id){
        res.status(404).send("Spice not found for update");
    }else {
        //else update spices at spiceIndex with updatedSpice
        spices[spiceIndex] = updatedSpice;
    }
});

router.delete('/:spiceId', (req, res, next) => {
    const spiceId = Number(req.params.id);
    const spiceIndex = spices.findIndex(spice => spice.id === spiceId);
    if (spiceIndex !== -1) {
      spices.splice(spiceIndex, 1);
      res.status(204).send();
    } else {
      res.status(404).send('Spice not found.');
    }
  });
  
  module.exports = router;