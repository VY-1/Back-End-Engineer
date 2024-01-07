const alienShip = {
    invade: function () { 
      console.log('Hello! We have come to dominate your planet. Instead of Earth, it shall be called New Xaculon.')
    }
};

alienShip["invade"]()

console.log()

alienShip.invade()

console["log"]("Testing")

// ----------------------------------------------------
console.log("====================================")

let retreatMessage = 'We no longer wish to conquer your planet. It is full of dogs, which we do not care for.';

// Write your code below
const enemyShip = {
  retreat () {
    console.log(retreatMessage);
  },
  takeOff () {
    console.log("Spim... Borp... Glix... Blastoff!");
  },
  fireGun: () => {
    console.log("Boom boom boommmm!");
  },
  burnIt: function () {
    console.log("Burning!!");
  }
};


enemyShip.retreat();

enemyShip.takeOff();

enemyShip.fireGun();
enemyShip.burnIt();


//----------------------------------------
console.log("======================================");

let spaceship = {
    passengers: null,
    telescope: {
      yearBuilt: 2018,
      model: "91031-XLT",
      focalLength: 2032 
    },
    crew: {
      captain: { 
        name: 'Sandra', 
        degree: 'Computer Engineering', 
        encourageTeam() { console.log('We got this!') },
       'favorite foods': ['cookies', 'cakes', 'candy', 'spinach'] }
    },
    engine: {
      model: "Nimbus2000"
    },
    nanoelectronics: {
      computer: {
        terabytes: 100,
        monitors: "HD"
      },
      'back-up': {
        battery: "Lithium",
        terabytes: 50
      }
    }
  }; 
  
  let capFave = spaceship.crew.captain["favorite foods"][0];
  
  console.log("captain's favorite food on index 0: " +capFave);

  spaceship.passengers = [{name: "Space Dog"}, {specieType: "Hybrid Dog"}];

  let firstPassenger = spaceship.passengers[0];
  console.log(firstPassenger);