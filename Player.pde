class Player {

  public float x, y;
  public final int spriteWidth = 53;
  public final int spriteHeight = 54;
  private final int FPS = 60;
  public int lives = 3;
  public float score = 0;
  public String name = "";
  private int lastMouseX;
  private int lastMouseY;
  private float velocityX;
  private float velocityY;
  public String state = "default";
  private int framesToDisplay;

  // constructor:
  Player (float x, float y) {
    this.x = x;
    this.y = y;

    // resets location to standard location:
    lastMouseX = (int) this.x;
    lastMouseY = (int) this.y;
  }

  public void performActions() {
    if (this.state != "default") {
      this.framesToDisplay--;

      if (framesToDisplay == 0) {
        this.state = "default";
      }
    }
    this.render();
    useMouse();
    this.move(); // move player
  }

  private void render() {
    tint(255, 255); // make image fully opaque
    if (state == "default") {
      image(playerSprite, this.x, this.y);
    } else {
      image(altPlayerSprite, this.x, this.y);
    }
  }

  private void useMouse() {
    // set where player should move to:
    if (mousePressed == true) {
      lastMouseX = mouseX;
      lastMouseY = mouseY;
      velocityX = ((this.x - lastMouseX)+spriteWidth/2) / FPS;
      velocityY = ((this.y - lastMouseY)+spriteWidth/2) / FPS;
    }
  }

  private void move() {

    if (canPlayerMove()) {

      // if player goes out of bounds move them back
      if (this.x + spriteWidth > 815) {
        this.x = 815 - spriteWidth;
      } else if (this.x < 82) {
        this.x = 82;
      } else {
        this.x = this.x-velocityX;
      }

      // if player goes out of bounds move them back
      if (this.y < 0) {
        this.y=0;
      } else if (this.y+spriteHeight > height) {
        this.y = height - spriteHeight;
      } else {
        this.y = this.y-velocityY;
      }
    }
  }

  private boolean canPlayerMove() {

    //required as other methods of getting player to move leads to acceleration or the player never stops moving:
    if (!((int)this.x+(spriteWidth/2) - lastMouseX <= 3 && (int)this.x+(spriteWidth/2) - lastMouseX >= -3 && (int)this.y+(spriteHeight/2)-lastMouseY <=3 && (int)this.y+(spriteHeight/2)-lastMouseY >= -3)) {
      return true;
    } else {
      return false;
    }
  }
}
