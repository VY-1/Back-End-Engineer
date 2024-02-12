//Find index of an array
// Write your code here:

const findMyKeys = (stringArr) => {
    return stringArr.findIndex(item => item === "keys");
  }
  
  
  
  // Feel free to comment out the code below to test your function
  
  const randomStuff = ['credit card', 'screwdriver', 'receipt', 'gum', 'keys', 'used gum', 'plastic spoon'];
  
  console.log(findMyKeys(randomStuff))
  // Should print 4
  