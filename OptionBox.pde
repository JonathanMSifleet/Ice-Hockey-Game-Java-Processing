class optionBox {

  private int x, y; 
  public int size;

  // constructor:
  optionBox(int x, int y, int size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }

  public void render() {
    rect(this.x, this.y, this.size, this.size);
  }

  public boolean detectMouse() {

    //detect if mouse is inside an option box
    if (mouseX >= this.x && mouseX <= this.x + size && mouseY >= this.y && mouseY <= this.y + size && mousePressed == true) {
      return true;
    } else {
      return false;
    }
  }
}
