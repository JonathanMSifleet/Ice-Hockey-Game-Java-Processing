class FastPuck extends Puck { //inheritance

  FastPuck(float x, float y) {
    super(x, y);
    this.circumference = 14;
  }

  @Override protected void createSpeeds() {
    if (tempSpeedX == 0 && tempSpeedY == 0) {
      this.speedY = createSpeedY() * multiplier;
      this.speedX = 5 * multiplier;
    } else {
      // set new speeds to previous speeds: 
      setTempSpeeds();
    }
  }

  @Override  protected int createSpeedY() {
    int tempSpeed = (int) (random(6, 5));

    // keep generating a y value until its not equal to 0
    do {
      if (tempSpeed == 0) {
        tempSpeed = (int)(random(-6, 5));
      }
    } while (tempSpeed == 0);

    return tempSpeed;
  }
}
