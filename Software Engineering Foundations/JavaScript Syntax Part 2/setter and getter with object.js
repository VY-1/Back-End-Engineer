const robot = {
    _model: '1E78V2',
    _energyLevel: 100,
    _numOfSensors: 15,
    get numOfSensors(){
      if(typeof this._numOfSensors === 'number'){
        return this._numOfSensors;
      } else {
        return 'Sensors are currently down.'
      }
    },
    set numOfSensors (num) {
      if (typeof num === "number" && num >= 0){
        this._numOfSensors = num;
      }
      else {
        console.log("Pass in a number that is greater than or equal to 0");
      }
    }
    
  };
  
  
  robot.numOfSensors = 100;
  
  console.log(robot.numOfSensors);

  //----------------------------------------------------
  //Object, class with parameter

  const robotFactory = (model, mobile) => { 
    return {
      model : model,
      mobile: mobile,
      beep() {
        console.log("Beep Boop");
      }
    }
  };
  
  const tinCan = robotFactory("P-500", true);
  
  tinCan.beep();

  //Short hand method
  const robotFactory2 = (model, mobile) => {
    return {
      model,
      mobile,
      beep() {
        console.log('Beep Boop');
      }
    }
  }
  
  // To check that the property value shorthand technique worked:
  const newRobot = robotFactory2('P-501', false)
  console.log(newRobot.model)
  console.log(newRobot.mobile)