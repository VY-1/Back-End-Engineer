console.log('hi');

const getUserChoice = (userInput) => {
  userInput = userInput.toLowerCase();
  if (userInput === "rock" || userInput === "scissors" || userInput === "paper" || userInput === "bomb") {
    return userInput;
  }
  else {
    console.log("Error, please type: rock, paper or scissors.");
  }

};


const getComputerChoice = () => {
  let computerInput = Math.floor(Math.random()*3);
  if (computerInput === 0){
    return "rock";
  }
  else if (computerInput === 1){
    return "paper";
  }
  else {
    return "scissors";
  }

};

const determineWinner = (userChoice, computerChoice) => {
  if(userChoice === "bomb"){
    return "You won!";
  }
  if (userChoice === computerChoice){
    return "Tie game!"
  }
  if (userChoice === "rock"){
    if (computerChoice === "paper")
      return "Computer won!";
    else
      return "You won!";

  }
  if (userChoice === "paper"){
    if(computerChoice === "scissors")
      return "Computer won!";
    else
      return "You won!";
  }
  if (userChoice === "scissors"){
    if(computerChoice === "rock")
      return "Computer won!";
    else
      return "You won!";
  }
};

const playGame = () => {
  let userChoice = getUserChoice("rock");
  let computerChoice = getComputerChoice();
  console.log("You choose: " + userChoice);
  console.log("Computer choose: " + computerChoice);
  let gameResult = determineWinner(userChoice, computerChoice);
  console.log(gameResult);
}

playGame();