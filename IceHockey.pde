//////////////////// //<>//
// NOTES:
// comments for specific lines will be
// parallel to the line, comments for
// blocks of code will be above it
////////////////////

PImage background, playerSprite, imgExplosion, altPlayerSprite;
PImage puckImg;

ArrayList<Explosion> explosionList = new ArrayList<Explosion>();

// creates object instances:
Puck[] arrayOfPucks = new Puck[5];
Player player1;
optionBox[] arrayOptionBox = new optionBox[3];
GoalFrame goalFrame;
ScoringBox scoringBox;
SplashScreen splashScreen;
GameOverScreen gameOverScreen;
UserInput userInput;
/////

//global variables:
float multiplier=1;
float tempSpeedX=0;
float tempSpeedY=0;
int frameCounter = 0; // time is unforunately linked to frames per second
// it's expected for processing to run at 60 fps
// so the amount of frames/60 gives you time elapsed (ish) 
boolean enterPressed = false;
boolean initialRun = true;
int normalisedFrameCounter=0;

void setup() {

  size(1222, 608);
  background = loadImage("sprites/hockeyBackground.png");
  playerSprite = loadImage("sprites/Player.png");
  imgExplosion = loadImage("sprites/imgExplosion.png");
  altPlayerSprite = loadImage("sprites/altPlayerSprite.png");
  
  // initializes objects:
  player1 = new Player(150, height/2);
  goalFrame = new GoalFrame();
  scoringBox = new ScoringBox();
  splashScreen = new SplashScreen();
  gameOverScreen = new GameOverScreen();
  userInput = new UserInput();

  // create option boxes:
  final int size = 200;
  arrayOptionBox[0] = new optionBox(width/6-(size/2), height/2-(size/2), size);
  arrayOptionBox[1] = new optionBox(width/2-(size/2), height/2-(size/2), size);
  arrayOptionBox[2] = new optionBox((width/6)*5-(size/2), height/2-(size/2), size);
}

void draw () { 

  if (focused == false) { // only run if program is focussed
    handleUnfocusedWindow();
  } else {

    // if less than ~ten seconds worth of frames have occured display the splash screen
    if (frameCounter < 300) {
      splashScreen.performActions();

      // get the user's name as long as enter hasn't been pressed:
    } else if (enterPressed == false) {
      userInput.performActions();

      if (keyPressed == true && key == ENTER) {
        enterPressed = true;
        player1.name= player1.name.substring(0, max(0, player1.name.length()-1)); // required to remove the new line created by pressing enter
        deleteSplashScreenObjects();
      }
    } else {
      doInitialRunFunctions();

      // main code:

      drawBackground(); // overwrite drawn spirtes

      goalFrame.render();
      scoringBox.render();
      doExplosionActions();
      doPuckActions();

      player1.performActions();
      drawTelemetry();

      checkAndHandlePlayerDeath();

      frameCounter++; // increase the frame counter

      increasePuckSpeedFunction();
      normalisedFrameCounter++;

      if (normalisedFrameCounter > 11) {
        normalisedFrameCounter = 0;
      } // end of if
    } // end of inner if
  } // end of outer if
} // end of draw function

void drawBackground () {
  image(background, 0, 0);
}

void drawTelemetry() {
  fill(0);
  textSize(20);
  textAlign(LEFT, LEFT);
  text("Score: " + int(player1.score), (width/5)*2, height/12);
  text("Lives: " + player1.lives, (width/5)*2, height/12+25);
  textSize(15);
  text("Time elapsed: " + ((frameCounter /60)-5), 150, height/17); //display time elapsed
}

void createPuck(int i) {
  if (i==3) {
    arrayOfPucks[i] = new FastPuck(width, (int) random(0, height));
  } else if (i==4) {
    arrayOfPucks[i] = new SlowPuck(width, (int) random(0, height));
  } else { 
    arrayOfPucks[i] = new Puck(width, (int) random(0, height));
  }

  // if the program hasn't already stop the pucks from overlapping when they're being created
  if (initialRun==false) {
    stopPucksOverlapping();
  }
}

void increasePuckSpeed() {
  for (int i = 0; i < arrayOfPucks.length; i++) {
    if (arrayOfPucks[i] != null) {
      // increase puck's speeds:
      arrayOfPucks[i].increaseSpeed();
    }
  }
}

void handlePlayerCollisions(int i) {

  boolean collision = arrayOfPucks[i].detectPlayerCollision(player1);

  // increase score based upon difficulty:
  if (collision == true) {
    if (arrayOfPucks[i].speedX >= 0) {
      player1.score = player1.score+arrayOfPucks[i].speedX;
    } else {
      player1.score = player1.score-arrayOfPucks[i].speedX;
    }    
    removePuck(i);
    player1.framesToDisplay = 30;
    player1.state = "alt"; // change player state
  }
}

void removePuck(int i) {

  explosionList.add(new Explosion(arrayOfPucks[i]));

  // delete puck and set temporary speeds:
  tempSpeedX = arrayOfPucks[i].speedX;
  tempSpeedY = arrayOfPucks[i].speedY;  
  arrayOfPucks[i] = null;
  System.gc(); // despite being told not to use the garbage collector
  // when creating 150 pucks the memory usage ballooned to 4GB,
  // with calls to the garbage collector it went down to 120MB
  createPuck(i);
}

void handlePuckInNet(int i) {
  boolean puckInGoal = arrayOfPucks[i].detectPuckInGoal(scoringBox);

  if (puckInGoal == true) {
    player1.lives--;
    removePuck(i);
  }
}

void handleUnfocusedWindow() {
  background(255, 255, 255);
  textAlign(CENTER, CENTER);
  textSize(75);
  fill(0);
  text("Please focus window!", width/2, height/2);
}

void deleteSplashScreenObjects() {
  for (int i =0; i < arrayOptionBox.length; i++) {
    arrayOptionBox[i] = null; // delete unused objects from memory
  }
  splashScreen = null; // delete unused objects from memory
  userInput = null;
}

void deleteMainGameObjects() {
  // delete pucks from memory:
  for (int i =0; i < arrayOfPucks.length; i++) {
    if (arrayOfPucks[i] != null) {
      arrayOfPucks[i] = null; // delete unused objects from memory
    }
  }
  goalFrame = null;
  scoringBox = null;
}

void doPuckActions() {

  boolean hasBounced = false;

  // do every pucks actions and collision detections:
  for (int i = 0; i < arrayOfPucks.length; i++) {
    arrayOfPucks[i].performActions(); // for every puck
    handlePlayerCollisions(i);
    hasBounced = arrayOfPucks[i].detectGoalCollisions();

    if (hasBounced == true) {
      handlePuckInNet(i);
    }
  }
}

void doExplosionActions() {
  // check if explosions need to be rendered
  for (int i = 0; i < explosionList.size(); i++) {
    if (explosionList.get(i).framesToDisplay != 0) {
      explosionList.get(i).render();
    } else {
      explosionList.remove(explosionList.get(i)); // remove explosion from the list
    }
  }
}

boolean detectStuckPuck() {
  // detects and removes stuck pucks during initialisation:
  for (int i = 0; i < arrayOfPucks.length; i++) {
    for (int j= 0; j< arrayOfPucks.length; j++) {
      if (i != j && arrayOfPucks[i].detectSelfCollision(arrayOfPucks[j]) == true) {
        removePuck(i);
        return true;
      }
    }
  }
  return false;
}

void stopPucksOverlapping() {
  boolean stuckPuck;

  // keep running until there are no stuck pucks
  do {
    stuckPuck = detectStuckPuck();
  } while (stuckPuck == true);
}

void doInitialRunFunctions() {

  // if it is the first run of draw() create the pucks
  if (initialRun == true) {
    // create pucks:
    for (int i = 0; i < arrayOfPucks.length; i++) {
      createPuck(i);
    }
    stopPucksOverlapping(); // handle stuck pucks
    initialRun = false;
  }
}

void checkAndHandlePlayerDeath() {
  if (player1.lives == 0) {
    gameOverScreen.performActions();
  }
}

void increasePuckSpeedFunction() {
  //every five seconds increase every puck's speed:
  if (((frameCounter-300) % 300) == 0) { 
    increasePuckSpeed();
  } // end of if
}
