class SlowPuck extends Puck { //inheritance

  SlowPuck(float x, float y) {
    super(x, y);
    this.circumference = 30;
  }

  @Override protected void createSpeeds() {
    if (tempSpeedX == 0 && tempSpeedY == 0) {
      this.speedY = createSpeedY() * multiplier;
      this.speedX = 1 * multiplier;
    } else {
      // set new speeds to previous speeds:
      setTempSpeeds();
    }
  }

  @Override protected int createSpeedY() {
    int tempSpeed = (int) (random(-2, 1));

    // keep generating a y value until its not equal to 0
    do {
      if (tempSpeed == 0) {
        tempSpeed = (int) (random(-2, 1));
      }
    } while (tempSpeed == 0);

    return tempSpeed;
  }
}
