
/*

The developers over at Super Encoder LLC heard about the encryptors.js module that you just released and want to use your encryption functions to create a new program.

The Super Encoder
The Super Encoder developers want the user to be able to use their program to encode messages and decode them using the commands below:

node super-encoder.js encode

and
node super-encoder.js decode
*/

// Import the encryptors functions here.
/*
const encryptors = require("./encryptors.js");
const caesarCipher = encryptors.caesarCipher;
const symbolCipher = encryptors.symbolCipher;
const reverseCipher = encryptors.reverseCipher;
*/
//Import using destructuring
const { caesarCipher, symbolCipher, reverseCipher } = require("./encryptors.js");

const encodeMessage = (str) => {
  // Use the encryptor functions here.
  //caesarCipher requires amount of shift 0-26 as argument
  const caesarEncrypted = caesarCipher(str, 5);
  const symbolEncrypted = symbolCipher(caesarEncrypted);
  const reverseEncrypted = reverseCipher(symbolEncrypted);

  return reverseEncrypted;

  
}

const decodeMessage = (str) => {
  // Use the encryptor functions here.
  const reverseDecoded = reverseCipher(str);
  const symbolDecoded = symbolCipher(reverseDecoded);
  const caesarDecoded = caesarCipher(symbolDecoded, -5);
  return caesarDecoded;
}

// User input / output.

const handleInput = (userInput) => {
  const str = userInput.toString().trim();
  let output;
  if (process.argv[2] === 'encode') {
    output = encodeMessage(str);
  } 
  if (process.argv[2] === 'decode') {
    output = decodeMessage(str);
  } 
  
  process.stdout.write(output + '\n');
  process.exit();
}

// Run the program.
process.stdout.write('Enter the message you would like to encrypt...\n> ');
process.stdin.on('data', handleInput);