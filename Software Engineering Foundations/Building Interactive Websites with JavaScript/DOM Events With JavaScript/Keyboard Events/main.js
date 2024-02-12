let ball = document.getElementById('float-circle');

// Write your code below
function up(){
  ball.style.bottom = "250px";
};

let down = function() {
  ball.style.bottom = "50px";
};

document.addEventListener("keydown", up);
document.addEventListener("keyup", down);

//document.onkeydown = up;
//document.onkeyup = down;