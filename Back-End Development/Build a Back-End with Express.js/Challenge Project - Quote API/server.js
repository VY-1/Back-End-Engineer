
const express = require("express");
const morgan = require("morgan");
const app = express();

const { getRandomElement } = require("./utils.js");
const { quotes } = require("./data.js");

const PORT = process.env.PORT || 4001;
app.use(express.static("public"));

// GET a random Quote.
app.get("/api/quotes/random", (req, res)=>{
    const randomQuote = getRandomElement(quotes);
    res.send({ quote: randomQuote });
});

app.get("/api/quotes", (req, res)=>{

    //filter quotes based on person
    const filterQuotes = quotes.filter(author=> author.person === req.query.person);
    if(!req.query.person){
        res.send({ quotes: quotes});
    }else {
        res.send({ quotes: filterQuotes});
    }
});

app.post("/api/quotes", (res, req)=>{
    const newQuote = req.query.quote;
    const newPerson = req.query.person;
    if(newQuote !=="" && newPerson !==""){
        quotes.push({ quote: newQuote, person: newPerson });
        res.send({ quote: { quote: newQuote, person: newPerson }});
    }else {
        res.send(400);
    }
});

app.put()

app.listen(PORT, ()=>{
    console.log(`Server started on PORT: ${PORT}`);
});