class ScoringBox {

  public final int y = 136;
  public final int x = 57;
  public final int boxWidth = 19;
  public final int boxHeight = 341;

  // constructor
  ScoringBox() {
  }

  public void render() {
    fill(0, 255, 0);
    rect(x, y, boxWidth, boxHeight); // top
  }
}
