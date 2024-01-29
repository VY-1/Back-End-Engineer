//Error Handling
//Try and Catch
try {
    throw Error("Error, you fail to execute proper program");
}catch (e){
    console.log(e);
}

console.log("-----------------------------------");

//---------------------------

function capAllElements(arr){
    //try catch block
    try {
      arr.forEach((el, index, array) => {
        array[index] = el.toUpperCase();
      });
    }catch (e){
      console.log(e);
    }
      
  }
  
  capAllElements(["This", "Will", "Not", "Work"]);
  capAllElements('Incorrect argument');
  