enum Difficulty {
  Easy, Medium, Hard;
}
class SplashScreen {

  Difficulty diff = Difficulty.Easy; // default difficulty
  private boolean boxHighlighted = false;
  // constructor
  SplashScreen() {
  }

  public void performActions() {

    this.render();
    this.renderOptions();

    // get difficulty based upon which box
    // is clicked on:
    for (int j = 0; j < arrayOptionBox.length; j++) {
      boxHighlighted = arrayOptionBox[j].detectMouse();
      selectDifficulty(boxHighlighted, j);
    }

    fill(0);
    textAlign(CENTER, CENTER);
    text("You have selected difficulty: " + diff.name(), width/2, (height/6)*5);

    frameCounter++; // increment frame counter
  }

  private void render() {
    background(255, 255, 255);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(25);
    text("You have " + ((300-frameCounter)/60) + " more seconds to choose a difficulty", width/2, height/6-10);
    text("Please select a difficulty:", width/2, (height/6)+30);
    textSize(18);
    fill(255, 0, 0);
    text("You cannot go into the attacking area, or behind the goal!", (width/2), ((height/12)*9)+10);
  }

  private void renderOptions() {

    String[] arrayOfDifficulties = {"Easy", "Medium", "Hard"};

    // show option boxes
    for (int j = 0; j < arrayOptionBox.length; j++) {
      fill(255, 255, 255);
      arrayOptionBox[j].render();

      textAlign(CENTER, CENTER);
      fill(0);
      textSize(25);
      text(arrayOfDifficulties[j], arrayOptionBox[j].x+(arrayOptionBox[j].size/2), arrayOptionBox[j].y+(arrayOptionBox[j].size/2));
    }
  }

  private void selectDifficulty(boolean boxHighlighted, int j) {

    if (boxHighlighted == true && mousePressed == true) {

      // use of enumerated set:
      switch (j) {
      case 0:
        diff = Difficulty.Easy; 
        multiplier = 1;
        break;
      case 1:
        diff = Difficulty.Medium;
        multiplier = 1.33;
        break;
      case 2:
        diff = Difficulty.Hard; 
        multiplier = 1.5;
        break;
      default:
        diff = Difficulty.Easy; 
        multiplier = 1;
        break;
      }

      fill(255, 165, 0, 100);
      arrayOptionBox[j].render();
    }
  }
}
