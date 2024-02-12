/*
Write a function groceries() that takes an array of object literals of grocery items. The function should return a string with each item separated by a comma except the last two items should be separated by the word 'and'. Make sure spaces (' ') are inserted where they are appropriate.

Examples:

groceries( [{item: 'Carrots'}, {item: 'Hummus'}, {item: 'Pesto'}, {item: 'Rigatoni'}] );
// returns 'Carrots, Hummus, Pesto and Rigatoni'

groceries( [{item: 'Bread'}, {item: 'Butter'}] );
// returns 'Bread and Butter'

groceries( [{item: 'Cheese Balls'}] );
// returns 'Cheese Balls'
*/

// Write function below
const groceries = (groceryObject) =>{
    let newGroceryList = [];
    for (let i = 0; i < groceryObject.length; i++){
  
      if (i === groceryObject.length-2){
        newGroceryList.push(groceryObject[i].item + " and");
        
      }
      else if (i === groceryObject.length-1){
        newGroceryList.push(groceryObject[i].item);
      }
      else {
        newGroceryList.push(groceryObject[i].item + ",");
      }
    }
    return newGroceryList.join(" ");    
    
  }
  
  console.log(groceries( [{item: 'Carrots'}, {item: 'Hummus'}, {item: 'Pesto'}, {item: 'Rigatoni'}] )
  );
  console.log(groceries( [{item: 'Bread'}, {item: 'Butter'}] ));
// returns 'Bread and Butter'

console.log(groceries( [{item: 'Cheese Balls'}] ));
// returns 'Cheese Balls'