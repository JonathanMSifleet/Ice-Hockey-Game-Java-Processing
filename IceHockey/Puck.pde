class Puck { //<>//

  public float x, y;
  public float speedX, speedY;
  protected final int dragValue = -1; //experimental
  protected float testX;
  protected float testY;
  public int circumference = 20;
  public int radius;
  private final float[] speeds = {4.5, 6};

  protected float distance;

  // constructor
  Puck(float x, float y) {

    // creates a random y direction if there are no temporary values
    createSpeeds();

    this.x = x;
    this.y = y;
    this.radius = this.circumference/2;
  }

  public void performActions() {

    // polymorphism:
    this.move();
    this.render();
    this.handleWindowCollision();
    handleSelfCollisions();
  }

  protected void move() {
    this.x = this.x-speedX;
    this.y = this.y-speedY;
  }

  protected void handleWindowCollision() {
    // detect if puck hits the program's windows
    // and then bounce
    if (this.x + this.radius > width) {
      this.x = width-this.radius;
      this.speedX = this.speedX * dragValue;
    }
    if (this.y + radius > height) {
      this.y= height-this.radius;
      this.speedY = this.speedY * dragValue;
    }
    if (this.x - this.radius < 0) {
      this.x = this.radius;
      this.speedX = this.speedX * dragValue;
    }
    if (this.y - this.radius < 0) {
      this.y = this.radius;
      this.speedY = this.speedY * dragValue;
    }
    // detect if object hits the window's side
  }

  protected void render() {

    float tempSpeedValue=0;

    tint(255, 255); // make image fully opaque

    // if the puck is moving backwards then "pretend" the speed is a positive value:
    if (this.speedX < 0) {
      tempSpeedValue = this.speedX *-1;
    } else {
      tempSpeedValue = this.speedX;
    }

    changeImage(tempSpeedValue);

    imageMode(CENTER);
    image(puckImg, this.x, this.y);
    imageMode(CORNER);
  }

  public boolean detectPlayerCollision(Player other) {

    // find distance between two objects
    // return true if they overlap (distance <= circumference)

    setTestValues();

    if (this.x < other.x) {     
      this.testX = other.x;        // left edge
    } else if (this.x > other.x+other.spriteWidth) {
      this.testX = other.x+other.spriteWidth;     // right edge
    }

    if (this.y < other.y) { 
      this.testY = other.y;        // top edge
    } else if (this.y > other.y+other.spriteHeight) {
      this.testY = other.y+other.spriteHeight;     // bottom edge
    }

    return detectCollision();
  }

  protected boolean detectBackOfFrame(GoalFrame other) {

    // find distance between two objects
    // return true if they overlap (distance <= circumference)

    setTestValues();

    if (this.x < other.x) { 
      this.testX = other.x; // detect left edge
    } else if (this.x > other.x+other.thickness) { 
      this.testX = other.x+other.thickness; // detect right edge
    }

    if (this.y < other.y) {  
      this.testY = other.y; // top edge
    } else if (this.y > other.y+other.goalHeight) { 
      this.testY = other.y+other.goalHeight; // detect bottom edge
    }

    return detectCollision();
  }

  protected boolean detectBottomOfFrame(GoalFrame other) {

    // find distance between two objects
    // return true if they overlap (distance <= circumference)

    setTestValues();

    if (this.x < other.x) { 
      this.testX = other.x; // detect left edge
    } else if (this.x > other.x+other.goalWidth) { 
      this.testX = other.x+other.goalWidth; // detect right edge
    }

    if (this.y < other.backY) {     
      this.testY = other.backY; // detect top edge
    } else if (this.y > other.backY+other.thickness) { 
      this.testY = other.backY+other.thickness; // detect bottom edge
    }

    return detectCollision();
  }

  protected boolean detectTopOfFrame(GoalFrame other) {

    // find distance between two objects
    // return true if they overlap (distance <= circumference)

    setTestValues();

    if (this.x < other.x) {   
      this.testX = other.x; // detect left edge
    } else if (this.x > other.x+other.goalWidth) { 
      this.testX = other.x+other.goalWidth; // detect right edge
    }

    if (this.y < other.y) {   
      this.testY = other.y; // detect top edge
    } else if (this.y > other.y+other.thickness) { 
      this.testY = other.y+other.thickness; // detect bottom edge
    }

    return detectCollision();
  }

  protected boolean detectPuckInGoal(ScoringBox other) {

    // find distance between two objects
    // return true if they overlap (distance <= circumference)

    setTestValues();

    if (this.x < other.x) {    
      this.testX = other.x; // left edge
    } else if (this.x > other.x+other.boxWidth) { 
      this.testX = other.x+other.boxWidth; // right edge
    }

    if (this.y < other.y) {     
      this.testY = other.y; // detect top edge
    } else if (this.y > other.y+other.boxHeight) { 
      this.testY = other.y+other.boxHeight; // detect bottom edge
    }

    return detectCollision();
  }

  protected void bounce() {
    //invert pucks direction:
    this.speedX = this.speedX * dragValue;
    this.speedY = this.speedY * dragValue;
  }

  protected boolean detectGoalCollisions() {

    // function to contain net collisions:
    boolean backOfNetCollision = false;
    boolean bottomOfNetCollision = false;
    boolean topOfNetCollision = false;

    backOfNetCollision = this.detectBackOfFrame(goalFrame);
    bottomOfNetCollision = this.detectBottomOfFrame(goalFrame);
    topOfNetCollision = this.detectTopOfFrame(goalFrame);

    if (backOfNetCollision == true || bottomOfNetCollision == true ||  topOfNetCollision == true) {
      this.bounce();
      return true;
    } else {
      return false;
    }
  }

  public boolean detectSelfCollision(Puck other) {

    // find distance between two objects
    // return true if they overlap (distance <= circumference)

    float distX = this.x - other.x;
    float distY = this.y - other.y;
    float distance = sqrt( (distX*distX) + (distY*distY) );

    if (distance <= this.radius+other.radius) {
      return true;
    } else {
      return false;
    }
  }

  protected int createSpeedY() {
    int tempSpeed = (int)(random(-4, 3));

    // keep generating a y value until its not equal to 0
    do {
      if (tempSpeed == 0) {
        tempSpeed = (int)(random(-4, 3));
      }
    } while (tempSpeed == 0);

    return tempSpeed;
  }

  protected void handleSelfCollisions() {

    // if the object is not itself, detect other objects:
    // i.e. detect other pucks
    for (int i = 0; i < arrayOfPucks.length; i++) {
      for (int j= 0; j< arrayOfPucks.length; j++) {
        if (i != j && arrayOfPucks[i].detectSelfCollision(arrayOfPucks[j]) == true) {
          arrayOfPucks[i].bounce();
        }
      }
    }
  }

  public void increaseSpeed() {
    this.speedX = this.speedX * 1.1;
    this.speedY = this.speedY * 1.1;
  }

  protected boolean distanceLessThancircumference() {
    if (distance <= this.circumference) {
      return true;
    } else {
      return false;
    }
  }

  protected float findDistance() {
    float distX = this.x - this.testX;
    float distY = this.y -this.testY;
    return sqrt((distX*distX) + (distY*distY));
  }

  protected boolean detectCollision() {
    this.distance = findDistance();
    return distanceLessThancircumference();
  }

  protected void setTestValues() {
    this.testX = this.x;
    this.testY = this.y;
  }

  protected void createSpeeds() {
    if (tempSpeedX == 0 && tempSpeedY == 0) {
      this.speedY = createSpeedY() * multiplier;
      this.speedX = 3 * multiplier;
    } else {
      // set new speeds to previous speeds: 
      setTempSpeeds();
    }
  }

  protected void setTempSpeeds() {
    this.speedX = tempSpeedX;
    this.speedY = tempSpeedY;
    tempSpeedX = 0;
    tempSpeedY = 0;
  }

  protected void changeImage(float tempSpeedValue) {

    String colour;
    int rotation =0;

    //gets the rotation based upon how many frames have elapsed

    if (normalisedFrameCounter < 3) {
      rotation =0;
    } else if (normalisedFrameCounter < 6) {
      rotation=45;
    } else if (normalisedFrameCounter <9) {
      rotation = 90;
    } else if (normalisedFrameCounter < 12) {
      rotation =135;
    }

    colour = changeColour(tempSpeedValue);

    puckImg = loadImage(colour+rotation+".png");
  }

  protected String changeColour(float tempSpeedValue) {
    // change colour based upon speed or type:
    if (this.circumference == 14 ) {
      return "fast";
    } else if (this.circumference == 30) {
      return "slow";
    } else if (tempSpeedValue <= speeds[0]) {
      return "green";
    } else if (tempSpeedValue <= speeds[1]) {
      return "orange";
    } else {
      return "red";
    }
  }
}
