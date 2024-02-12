/*
The Error Module
The Node environment’s
The Node environment’s error module has all the standard JavaScript errors such as EvalError, SyntaxError, RangeError, ReferenceError, TypeError, and URIError as well as the JavaScript Error class for creating new error instances. Within our own code, we can generate errors and throw them, and, with synchronous code in Node, we can use error handling techniques such as try...catch statements. Note that the error module is within the global scope—there is no need to import the module with the require() statement.

Many asynchronous Node APIs use error-first callback functions—callback functions which have an error as the first expected argument and the data as the second argument. If the asynchronous task results in an error, it will be passed in as the first argument to the callback function. If no error was thrown, the first argument will be undefined.

const errorFirstCallback = (err, data)  => {
  if (err) {
    console.log(`There WAS an error: ${err}`);
  } else {
    // err was falsy
    console.log(`There was NO error. Event data: ${data}`);
  }
}

1.
In order to
In order to understand why Node uses error-first callbacks in many of its asynchronous APIs, let’s demonstrate that traditional try...catch statements won’t work for errors thrown during asynchronous operations.

In naiveAsyncErr.js, we require in the local api.js module which contains the api.naiveErrorProneAsyncFunction() method. This asynchronous method throws an error whenever it is passed the input 'problematic input'. We would want the try...catch statement in naiveAsyncErr.js to catch this error, but it cannot since the error is thrown asynchronously.

In the terminal, execute the naiveAsyncErr.js file. You’ll see that the intended output, Something went wrong. ${err}\n, wasn’t logged— meaning that the error was never caught.
*/

const api = require('./api.js');

// Not an error-first callback
let callbackFunc = (data) => {
   console.log(`Something went right. Data: ${data}\n`);
};
  
try {
  api.naiveErrorProneAsyncFunction('problematic input', callbackFunc);
} catch(err) {
  console.log(`Something went wrong. ${err}\n`);
}

