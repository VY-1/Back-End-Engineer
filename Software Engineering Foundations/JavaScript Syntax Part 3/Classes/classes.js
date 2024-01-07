class HospitalEmployee {
    //constructor method always get executed during init new instance of the object
    constructor(name) {
      this._name = name;
      this._remainingVacationDays = 20;
    }
    
    get name() {
      return this._name;
    }
    
    get remainingVacationDays() {
      return this._remainingVacationDays;
    }
    
    takeVacationDays(daysOff) {
      this._remainingVacationDays -= daysOff;
    }
  
    //Static method that can only be called within HospitalEmployee class
    static generatePassword() {
      return Math.floor(Math.random()*10000);
    }
  }
  
  class Nurse extends HospitalEmployee {
    constructor(name, certifications) {
      //suopper calls the constructor of a parent class
      super(name);
      this._certifications = certifications;
    } 
    
    get certifications() {
      return this._certifications;
    }
    
    addCertification(newCertification) {
      this.certifications.push(newCertification);
    }
  }
  
  const nurseOlynyk = new Nurse('Olynyk', ['Trauma','Pediatrics']);
  nurseOlynyk.takeVacationDays(5);
  console.log(nurseOlynyk.remainingVacationDays);
  nurseOlynyk.addCertification('Genetics');
  console.log(nurseaOlynyk.certifications);
  
  //calling static method
  console.log(HospitalEmployee.generatePassword());
  