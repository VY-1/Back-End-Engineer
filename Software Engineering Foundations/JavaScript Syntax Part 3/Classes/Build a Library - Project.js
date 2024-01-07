/*
Build a Library
Congratulations, you’ve become head librarian at your local Books-‘N-Stuff, which is in dire need of your help. They’re still using index cards to organize their content! Yikes.

But no matter,
But no matter, you know some JavaScript, so let’s get to work modernizing your new digs.

Books-‘N-Stuff carries three different types of media: books, CDs, and movies. In this project you will create a parent class named Media with three subclasses: Book, Movie, and CD. These three subclasses have the following properties and methods:

Book
Properties: author (string), title (string), pages (number), isCheckedOut (boolean, initially false), and ratings (array, initially empty).
Getters: all properties have a getter
Methods: .getAverageRating(), .toggleCheckOutStatus(), and .addRating()
Movie
Properties: director (string), title (string), runTime (number), isCheckedOut (boolean, initially false), and ratings (array, initially empty)
Getters: all properties have a getter
Methods: .getAverageRating(), .toggleCheckOutStatus(), and .addRating()
CD
Properties: artist (string), title (string), isCheckedOut (boolean, initially false), and ratings (array, initially empty), songs (array of strings)
Getters: all properties have a getter
Methods: .getAverageRating(), .toggleCheckOutStatus(), and .addRating()
If you’re looking for a challenge, try to create the four classes without using the steps below.
*/

class Media {
    constructor(title){
      this._title = title;
      this._isCheckedOut = false;
      this._ratings = [];
    };
  
    get title() {
      return this._title;
    };
    get isCheckedOut() {
      return this._isCheckedOut;
    };
    get ratings() {
      return this._ratings;
    };
    set isCheckedOut(checkedOut) {
      this._isCheckedOut = checkedOut;
    };
  
    toggleCheckOutStatus() {
      this._isCheckedOut = !this.isCheckedOut;
    };
  
    getAverageRating() {
      //sums up using reduce method
      const sumWithInitial = this.ratings.reduce((currentSum, rating) => currentSum + rating, 0);
  
      return sumWithInitial/this.ratings.length;
    };
  
    addRating(rate) {
      this.ratings.push(rate);
    };
  
  };
  
  class Book extends Media {
    constructor(author, title, pages) {
      super(title);
      this._author = author;
      this._pages = pages;
  
    };
    get author() {
      return this._author;
    };
    get pages() {
      return this.pages;
    };
  
  };
  
  class Movie extends Media {
    constructor(director, title, runTime){
      super(title);
      this._director = director;
      this._runTime = runTime;
  
    };
    get director() {
      return this._director;
    };
    get runTime() {
      return this._runTime;
    };
  };
  
  //TEST
  const media1 = new Media ("GoGo Dog");
  media1.addRating(5);
  media1.addRating(4);
  console.log(media1.getAverageRating());
  
  //Testing Book instance
  const historyOfEverything = new Book("Bill Bryson", "A Short History of Nearly Everything", 544);
  
  historyOfEverything.toggleCheckOutStatus();
  console.log(historyOfEverything.isCheckedOut);
  historyOfEverything.isCheckedOut = false;
  console.log(historyOfEverything.isCheckedOut);
  historyOfEverything.addRating(4);
  historyOfEverything.addRating(5);
  historyOfEverything.addRating(5);
  console.log(historyOfEverything.getAverageRating());
  
  //Testing Movie instance
  const speed = new Movie("Jan de Bont", "Speed", 116);
  speed.toggleCheckOutStatus();
  console.log(speed.isCheckedOut);
  speed.addRating(1);
  speed.addRating(1);
  speed.addRating(5);
  console.log(speed.getAverageRating());
  