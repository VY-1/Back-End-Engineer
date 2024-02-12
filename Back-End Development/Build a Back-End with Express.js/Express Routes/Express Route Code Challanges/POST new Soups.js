const express = require('express');
const app = express();

const PORT = process.env.PORT || 4001;

const soups = ['gazpacho', 'borscht', 'primordial', 'avgolemono', 'laksa'];

app.get("/soups", (req, res, next)=>{
    res.send(soups);
});
app.post('/soups', (req, res, next) => {
  const name = req.query.name
  soups.push(name);
  res.status(201).send(name);
})

app.listen(PORT, () => {
  console.log(`Server is listening on port ${PORT}`);
});

