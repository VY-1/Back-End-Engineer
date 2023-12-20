let humanScore = 0;
let computerScore = 0;
let currentRoundNumber = 1;

// Write your code below:

// function to generate number from 0-9
const generateTarget = () => {
    const randomNumber = Math.floor(Math.random() *10);
    return randomNumber;
}

const getAbsoluteDistance = (guess, generatedNumber) =>{
    return Math.abs(generatedNumber-guess);
}

const numrand = generateTarget();

const compareGuesses = (humanGuess, computerGuess, numrand) => {

    humanGuess = getAbsoluteDistance(humanGuess, numrand);
    computerGuess = getAbsoluteDistance(computerGuess, numrand);
    /*
    console.log("generated number: " + numrand);
    console.log("human guess: " + humanGuess);
    console.log("computer guess: " + computerGuess);
    */

    //if tie, human win, return true
    if(humanGuess === computerGuess){
        return true;
    }
    else if (humanGuess<computerGuess){
        return true;
    }
    else {
        return false;
    }
    
}



// function use to update human and computer's scores
const updateScore = (winner) => {
    // let humanScore = 0;
    // let computerScore = 0;
    if (winner === "human"){
        humanScore +=1;
    }
    if (winner === "computer"){
        computerScore +=1;
    }
}

//function use to advance to next round
const advanceRound = () => {
    currentRoundNumber +=1;
}