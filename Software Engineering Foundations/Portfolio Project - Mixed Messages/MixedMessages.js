//Inspirational Quotes

const originalQuotes = [
    { name: "Queen Elizabeth II", message: "It is often the small steps, not the giant leaps, that bring about the most lasting change." },
    { name: "Nelson Mandela", message: "Education is the most powerful weapon which you can use to change the world." },
    { name: "Amanda Gorman", message: "There is always light. If only we're brave enough to see it. If only we're brave enough to be it." },
    { name: "Booker T. Washington", message: "If you want to lift yourself up, lift up someone else." },
    { name: "Cicely Tyson", message: "I have learned not to allow rejection to move me." },
    { name: "André Leon Talley", message: "I scorched the earth with my talent and I let my light shine."},
    { name: "A.A. Milne", message: "You’re braver than you believe, stronger than you seem, and smarter than you think." },
    { name: "Madeleine Albright", message: "It took me quite a long time to develop a voice, and now that I have it, I am not going to be silent." },
    { name: "Lupita Nyong'o", message: "You can't rely on how you look to sustain you, what sustains us, what is fundamentally beautiful is compassion; for yourself and your those around you." },
    { name: "Winston Churchill", message: "Attitude is the 'little' thing that makes a big difference." }
];

//map authors from originalQuotes to authors
const authors = originalQuotes.map(quote => quote.name);

//map messages from originalQuotes to messages
const messages = originalQuotes.map(quote => quote.message);

//random generating function
const randomPickIndex = inputArray => {
    return Math.floor(Math.random() * inputArray.length);
}

const randomQuote = [];

const randomAuthorAndMessage = {
    name : authors[randomPickIndex(authors)],
    message : messages[randomPickIndex(messages)],
    originalQuote () {
        return originalQuotes.filter(quote => quote.message === this.message)
    }
} 


console.log(`Your inspirational quote random author and random quote of the day:\nAuthor: ${randomAuthorAndMessage.name}\nQuote: ${randomAuthorAndMessage.message}\n\nOriginal Quote by:\n${randomAuthorAndMessage.originalQuote()[0].name} - ${randomAuthorAndMessage.originalQuote()[0].message}`);


//TEST
//console.log(authors);
//console.log(messages);
//console.log(randomAuthorAndMessage);
//console.log(randomAuthorAndMessage.originalQuote());