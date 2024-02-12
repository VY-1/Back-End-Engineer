/*
Making an async POST Request
Since we’ve reviewed the boilerplate code for an async POST request, the next step is to incorporate that logic into making a real request.

In this exercise, we’ll need to retrieve our Rebrandly API key to access the Rebrandly API.

We will then pass in the endpoint and the request object into the fetch() method to make our POST request.

If you reset the exercise at any point, you will have to paste in your API key again at the top!
*/

// information to reach API
const apiKey = '<ENTER YOUR API KEY HERE>';
const url = 'https://api.rebrandly.com/v1/links';

// Some page elements
const inputField = document.querySelector('#input');
const shortenButton = document.querySelector('#shorten');
const responseField = document.querySelector('#responseField');

// Asyncrhonous functions
const shortenUrl = async ()=>{
    const urlToShorten = inputField.value;
    const data = JSON.stringify({destination: urlToShorten});

    try{
        const response = await fetch(url, {
            method: "POST",
            headers: { "Content-type": "application/json", "apikey": apiKey},
            body: data
        });
        if(response.ok){
            const jsonResponse = await response.json();
            renderWordResponse(jsonResponse);
        }
    }catch(error){
        console.log(error);
    }
}

// Clear page and call Asynchronous functions
const displayShortUrl = (event) =>{
    event.preventDefault();
    while(responseField.firstChild){
        responseField.removeChild(responseField.firstChild);
    }
    shortenUrl();
}

shortenButton.addEventListener("click", displayShortUrl);