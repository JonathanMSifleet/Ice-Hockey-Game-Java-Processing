class UserInput {

  // constructor:
  UserInput() {
  }

  public void performActions() {
    userInput.render();
    getUserName();
    text("Your name is: " + player1.name, width/2, height/2);
  }

  private void render() {
    background(255, 255, 255);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(25);
    text("Press enter when your name is correct.", width/2, height/6+25);
  }

  private void getUserName() {

    // edit user's name based upon user input:
    if (keyPressed == true && key != BACKSPACE) {
      player1.name = player1.name + key;
      delay(180); // without this pressing a button will display multiple of the key pressed
    } else if (keyPressed == true && key == BACKSPACE) {
      player1.name= player1.name.substring(0, max(0, player1.name.length()-1)); //allows backspace to actually delete the letter
      delay(120); // without this pressing a button will delete lots of keys pressed
    }
  } // end of function
} // end of class
