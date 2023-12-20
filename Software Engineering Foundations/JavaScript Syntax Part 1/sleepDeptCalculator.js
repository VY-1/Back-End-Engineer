
const getSleepHours = (day) => {
    switch (day){
      case "monday":
        return 8;
      case "tuesday":
        return 7;
      case "wednesday":
        return 8;
      case "thursday":
        return 7;
      case "friday":
        return 6;
      case "saturday":
        return 9;
      case "sunday":
        return 6;
      default:
        return "Error!";
    }
  };
  
  const getActualSleepHours = () => getSleepHours("monday") + getSleepHours("tuesday") + getSleepHours("wednesday") + getSleepHours("thursday") + getSleepHours("friday") + getSleepHours("saturday") + getSleepHours("sunday");
  
  console.log(getActualSleepHours());
  
  const getIdealSleepHours = () => {
    let idealHours = 8;
    return idealHours * 7;
  };
  
  const calculateSleepDept = () => {
    let actualSleepHours = getActualSleepHours();
    let idealSleepHours = getIdealSleepHours();
    if (actualSleepHours === idealSleepHours){
      console.log("You got the perfect amount of sleep");
    }
    else if( actualSleepHours > idealSleepHours){
      console.log("You got more sleep than needed. " + (actualSleepHours - idealSleepHours) + " hour over ideal hours");
    }
    else{
      console.log("You should get more rest. " + (idealSleepHours - actualSleepHours) + " hours under ideal hours");
    }
  };
  
  calculateSleepDept();