class GoalFrame {

  public final int y = 133;
  public final int x = 54;
  public final int thickness = 3;
  public final int goalWidth = 22;
  public final int goalHeight = 347;
  public final int backY = 477;

  // constructor:
  GoalFrame () {
  }

  public void render() {
    rect(x, y, goalWidth, thickness); // top
    rect(x, y, thickness, goalHeight); //back
    rect(x, backY, goalWidth, thickness); //bottom
  }
}  
