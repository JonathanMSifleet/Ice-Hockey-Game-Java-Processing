class Explosion {

  private float x;
  private float y;
  //private final int imgWidth = 46;
  public int framesToDisplay = 60;

  Explosion(Puck other) {
    this.x = other.x-other.radius;
    this.y = other.y-other.radius;
    //this.framesToDisplay ;
  }

  public void render() {
    imageMode(CENTER);
    tint(255, (int) (255/60)*this.framesToDisplay); // make image fade
    image(imgExplosion, this.x, this.y);
    imageMode(CORNER);
    this.framesToDisplay--;
  }
}
