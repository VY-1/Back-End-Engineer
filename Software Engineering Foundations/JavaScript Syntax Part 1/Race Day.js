let raceNumber = Math.floor(Math.random() * 1000);

let earlyRegister = true;

let age  = 30;

if (age >18 && earlyRegister) {
  raceNumber = raceNumber + 1000;
}

if (age >18 && earlyRegister){
  console.log(`Race will begin at 9:30 am. Race # ${raceNumber}`);
}

else if (age > 18 && !earlyRegister){
  console.log(`Race will begin at 11 am. Race # ${raceNumber}`);
}

else if (age < 18){
  console.log(`Race will begin at 12:30 pm. Race # ${raceNumber}`);
}
else {
  console.log("See the registration desk");
}