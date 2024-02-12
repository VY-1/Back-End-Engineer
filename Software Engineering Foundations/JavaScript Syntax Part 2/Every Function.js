//Check if every item is vegan

const isVegan = (food) => {
    if (food.source === "plant"){
      return true;
    }
    else {
      return false;
    }
  };
  
  const isTheDinnerVegan = (dinnerArray) => {
    return dinnerArray.every(isVegan);
  }
  
  
  
  // Feel free to comment out the code below to test your function
  
  const dinner = [{name: 'hamburger', source: 'meat'}, {name: 'cheese', source: 'dairy'}, {name: 'ketchup', source:'plant'}, {name: 'bun', source: 'plant'}, {name: 'dessert twinkies', source:'unknown'}];
  
  console.log(isTheDinnerVegan(dinner))
  // Should print false
  