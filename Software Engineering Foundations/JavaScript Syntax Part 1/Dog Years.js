// my age in year
let myAge = 30;
// first 2 years in dog year
let earlyYears = 2;

earlyYears *= 10.5;

// dog years after the first 2 years
let laterYears = myAge - 2;

// dog years for laterYears
laterYears *=4;

console.log(earlyYears);
console.log(laterYears);

// my age in dog year
let myAgeInDogYears = earlyYears + laterYears;

// myName assign an convert all into lower case
let myName = "David".toLowerCase();

console.log(`My name is ${myName}. I am ${myAge} years old in human years which is ${myAgeInDogYears} years old in dog years`);