/*
Handling Errors
When .catch() is used with a long promise chain, there is no indication of where in the chain the error was thrown. This can make debugging challenging.

With async...await, we use try...catch statements for error handling. By using this syntax, not only are we able to handle errors in the same way we do with synchronous code, but we can also catch both synchronous and asynchronous errors. This makes for easier debugging!

async function usingTryCatch() {
 try {
   let resolveValue = await asyncFunction('thing that will fail');
   let secondValue = await secondAsyncFunction(resolveValue);
 } catch (err) {
   // Catches any errors in the try block
   console.log(err);
 }
}

usingTryCatch();

Remember, since async functions return promises we can still use native promise’s .catch() with an async function

async function usingPromiseCatch() {
   let resolveValue = await asyncFunction('thing that will fail');
}

let rejectedPromise = usingPromiseCatch();
rejectedPromise.catch((rejectValue) => {
console.log(rejectValue);
})

This is sometimes used in the global scope to catch final errors in complex code.
*/

const cookBeanSouffle = require("./HandlingErrors-Library.js");

//async function
async function hostDinnerParty(){
    try{
        let dinner = await cookBeanSouffle();
        console.log(`${dinner} is served!`);

    }catch(error){
        console.log(error);
        console.log("Ordering a pizza!")
    }
};

hostDinnerParty();