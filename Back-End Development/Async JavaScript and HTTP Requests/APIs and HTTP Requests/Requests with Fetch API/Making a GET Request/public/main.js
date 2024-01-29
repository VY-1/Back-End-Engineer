/*
Making a GET Request
In the previous exercise, we went over the boilerplate code for a GET request using fetch() and .then(). In this exercise, we’re going to apply that code to access the Datamuse API and render the fetched information in the browser.

The Datamuse API is a word-finding query engine for developers. It can be used in apps to find words that match a given set of constraints that are likely in a given context.

If the request is successful, we’ll get back an array of words that sound like the word we typed into the input field.

We may get some errors as we complete each step. This is because sometimes we’ve split a single step into one or more steps to make it easier to follow. By the end, we should be getting no errors.

Note: You may use the Console tab in DevTools to view the output (including errors) that your code produces. To open DevTools, type Shift + CTRL + J (on Windows/Linux) or Option + ⌘ + J (on macOS), then select the Console tab. Check out our article on DevTools to learn more.
*/


// Information to reach API
const url = 'https://api.datamuse.com/words?sl=';

// Selects page elements
const inputField = document.querySelector('#input');
const submit = document.querySelector('#submit');
const responseField = document.querySelector('#responseField');

// Asynchronous function
const getSuggestions = () => {
  const wordQuery = inputField.value;
  const endpoint = `${url}${wordQuery}`;
  
  fetch(endpoint, {cache: 'no-cache'}).then(response => {
    if (response.ok) {
      return response.json();
    }
    throw new Error('Request failed!');
  }, networkError => {
    console.log(networkError.message)
  })
  .then((jsonResponse)=>{
    //the second then takes jsonResponse and render to the page
    //renderRawResponse(jsonResponse);
    renderResponse(jsonResponse);
  })
}

// Clears previous results and display results to webpage
const displaySuggestions = (event) => {
  event.preventDefault();
  while(responseField.firstChild){
    responseField.removeChild(responseField.firstChild);
  }
  getSuggestions();
};

submit.addEventListener('click', displaySuggestions);
