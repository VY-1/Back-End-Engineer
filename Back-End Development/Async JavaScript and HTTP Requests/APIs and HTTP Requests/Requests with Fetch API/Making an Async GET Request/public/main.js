/*
Making an async GET Request
In the previous exercise, we walked through the boilerplate code for making a GET request using async and await.

In this exercise, we’re going to apply the code to get nouns that describe the inputted word using the Datamuse API.
*/

// Information to reach API
const url = 'https://api.datamuse.com/words?';
const queryParams = 'rel_jja=';

// Selecting page elements
const inputField = document.querySelector('#input');
const submit = document.querySelector('#submit');
const responseField = document.querySelector('#responseField');

// Asynchronous function
// Code goes here
const getSuggestions = async ()=>{
  const wordQuery = inputField.value;
  const endpoint = url + queryParams + wordQuery;

  try{
    //use await to wait for promise resolve
    const response = await fetch(endpoint, {cache: "no-cache"});
    if(response.ok){
      const jsonResponse = await response.json();
      renderResponse(jsonResponse);
    }

  }catch(error){
    console.log(error);
  }

}

// Clear previous results and display results to webpage
const displaySuggestions = (event) => {
  event.preventDefault();
  while(responseField.firstChild){
    responseField.removeChild(responseField.firstChild)
  }
  getSuggestions();
}

submit.addEventListener('click', displaySuggestions);
