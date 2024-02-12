/*
School Catalogue
Let’s put your knowledge of classes to the test by creating a digital school catalog for the New York City Department of Education. The Department of Education wants the catalog to hold quick reference material for each school in the city.

We need to
We need to create classes for primary and high schools. Because these classes share properties and methods, each will inherit from a parent School class. Our parent and three child classes have the following properties, getters, setters, and methods:
*/

class School {
    constructor(name, level, numberOfStudents){
      this._name = name;
      this._level = level;
      this._numberOfStudents = numberOfStudents;
      
    };
    get name() {
      return this._name;
    };
    get level() {
      return this._level;
    };
    get numberOfStudents() {
      return this._numberOfStudents;
    };
    set numberOfStudents(newNumberOfStudents){
      if (typeof(newNumberOfStudents) === "number"){
        this._numberOfStudents = newNumberOfStudents;
      }
      else {
        console.log("Invalid input: numberOfStudents must be set to a Number.");
      }
    };
  
    quickFacts() {
      console.log(`${this.name} educates ${this.numberOfStudents} students at the ${this.level} school level.`);
  
    };
    static pickSubstituteTeacher(substituteTeacher) {
      const teacherIndex = Math.floor(Math.random()* substituteTeacher.length);
      return substituteTeacher[teacherIndex];
  
    };
  
  };
  
  class PrimarySchool extends School {
    constructor(name, numberOfStudents, pickupPolicy){
      super(name, "primary", numberOfStudents);
      this._pickupPolicy = pickupPolicy;
    };
    get pickupPolicy() {
      return this._pickupPolicy;
    }
  };
  
  class HighScoool extends School {
    constructor(name, numberOfStudents, sportsTeams) {
      super(name, "high", numberOfStudents);
      this._sportsTeams = sportsTeams;
    };
    get sportsTeams() {
      console.log(this._sportsTeams);
    };
    set sportsTeams(newSportsTeam) {
      this._sportsTeams.push(newSportsTeam);
    };
  
  };
  
  
  //TEST
  const highSchool1 = new School("Wilson High", "High School", 500);
  
  highSchool1.numberOfStudents = 300;
  console.log(highSchool1.numberOfStudents);
  
  //Test PrimarySchool
  const lorraineHansbury = new PrimarySchool("Lorraine Hansbury", 514, "Students must be picked up by a parent, guardian, or a family member over the age of 13.");
  lorraineHansbury.quickFacts();
  const newSubstituteTeacher = School.pickSubstituteTeacher(['Jamal Crawford', 'Lou Williams', 'J. R. Smith', 'James Harden', 'Jason Terry', 'Manu Ginobli']);
  console.log(newSubstituteTeacher);
  
  //Test HighSchool 
  const alSmith = new HighScoool("Al E. Smith", 415, ['Baseball', 'Basketball', 'Volleyball', 'Track and Field']);
  alSmith.sportsTeams;
  