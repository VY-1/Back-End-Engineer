/*
The async Keyword
The async keyword is used to write functions that handle asynchronous actions. We wrap our asynchronous logic inside a function prepended with the async keyword. Then, we invoke that function.

async function myFunc() {
  // Function body here
};

myFunc();

We’ll be using async function declarations throughout this lesson, but we can also create async function expressions:

const myFunc = async () => {
  // Function body here
};

myFunc();

async functions always return a promise. This means we can use traditional promise syntax, like .then() and .catch with our async functions. An async function will return in one of three ways:

If there’s nothing returned from the function, it will return a promise with a resolved value of undefined.
If there’s a non-promise value returned from the function, it will return a promise resolved to that value.
If a promise is returned from the function, it will simply return that promise
async function fivePromise() { 
  return 5;
}

fivePromise()
.then(resolvedValue => {
    console.log(resolvedValue);
  })  // Prints 5

In the example above, even though we return 5 inside the function body, what’s actually returned when we invoke fivePromise() is a promise with a resolved value of 5.
*/


function withConstructor(num){
    return new Promise((resolve, reject) => {
      if (num === 0){
        resolve('zero');
      } else {
        resolve('not zero');
      }
    });
  }
  
  withConstructor(0, "Me")
    .then((resolveValue) => {
    console.log(` withConstructor(0) returned a promise which resolved to: ${resolveValue}.`);
  });
  
  // Write your code below:
  
  //same function using "async"
  const withAsync = async (num)=>{
    if (num === 0){
      return "zero";
    }else {
      return "not zero";
    }
  }
  
  
  
  // Leave this commented out until step 3:
  
  withAsync(100)
    .then((resolveValue) => {
    console.log(` withAsync(100) returned a promise which resolved to: ${resolveValue}.`);
  })