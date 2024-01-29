// NOTE: wordSmith functions from lines 4 - 41
// NOTE: byteSize functions from lines 43 - 85 (remember to add your API key!)
//API Key for byteSize functoin
const apiKey = "<ENTER YOUR APIKEY HERE>";
/*
wordSmith
*/
// Information to reach API
const dataMuseUrl = "https://api.datamuse.com/words?";
const queryParams = "rel_jja=";

// Selecting page elements
const inputField = document.querySelector("#input");
const submit = document.querySelector("#submit");
const responseField = document.querySelector("#responseField");

// Asynchronous function
const getSuggestions = async ()=>{
    const wordQuery = inputField.value;
    const endpoint = dataMuseUrl+queryParams+wordQuery;

    //try catch block to execute endpoint
    try {
        const response = await fetch(endpoint, {cache: "no-cache"});
        //if response returns OK status perform task
        if(response.ok){
            const jsonResponse = await response.json();
            //call renderWordRepsonse function from helperFunctions.js to display data
            renderWordResponse(jsonResponse);
        }
    }catch(error){
        console.log(error);
    }
}

// Clear provous results and display results to webpage
const displaySuggestions = (event)=>{
    event.preventDefault();
    //while there is a chil object in <div id="responseField"> exists, remove the firstChild object
    while(responseField.firstChild){
        responseField.removeChild(responseField.firstChild);
    };
    //execute getSuggestions() function to display data
    getSuggestions();
}

//addEventListener to submit button to display when click
submit.addEventListener("click", displaySuggestions);


/*
byteSize
*/
// information to reach API

const rebrandlyEndpoint = 'https://api.rebrandly.com/v1/links';

// Some page elements
const shortenButton = document.querySelector("#shorten");

// Asynchronous functions
const shortenUrl = async ()=>{
    const urlToShorten = inputField.value;
    //convert Javascript Object to JSON data
    const data = JSON.stringify({destination: urlToShorten});

    //try catch block
    try {
        const response = await fetch(rebrandlyEndpoint, {
            method: "POST",
            body: data,
            headers: { "Content-type": "application/json", "apikey": apiKey}
        });
        if(response.ok){
            const jsonResponse = await response.json();
            //call renderByteResponse() to display jsonResonse data
            renderByteResponse(jsonResponse);
        }
    }catch(error){
        console.log(error);
    }
}


// Clear page and call Asynchronous functions
const displayShortUrl = (event) => {
    event.preventDefault();
    while(responseField.firstChild){
      responseField.removeChild(responseField.firstChild);
    }
    //execute shortenUrl function to display data
    shortenUrl();
}
  
//addEventLister to shortenButton on click to display
shortenButton.addEventListener('click', displayShortUrl);
  