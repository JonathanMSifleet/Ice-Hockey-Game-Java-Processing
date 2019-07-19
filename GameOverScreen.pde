class GameOverScreen { //<>// //<>//

  // constructor:
  GameOverScreen() {
  }

  public void performActions() {

    ArrayList<String> lines = new ArrayList<String>(); // array list of lines
    final String dataToWrite = ((int) player1.score) + ", " + player1.name;
    
    //fileName will need to changed to an absolute path in order for files to not be overwritten:
    String fileName = "Scores.txt";
    /////
    
    String[] arrayOfLines = loadStrings(fileName); // creates array of all the lines in the scores file

    File file = new File(fileName);

    if (file.exists() == true) {
      this.writeScoresToFile(fileName, dataToWrite, arrayOfLines, lines);
    } else {
      this.createNewFileAndScore(fileName, dataToWrite);
    }

    deleteMainGameObjects();

    int[] arrayOfScores = new int[arrayOfLines.length];
    String [] arrayOfNames = new String[arrayOfLines.length];

    splitArrayLine(arrayOfLines, arrayOfScores, arrayOfNames); // splits array of lines into two seperate arrays

    sortArrayInReverse(arrayOfScores, arrayOfNames);

    this.render();
    this.renderTopScores(arrayOfScores, arrayOfNames);
    noLoop(); //stops draw being rendered again
  }

  private void splitArrayLine(String[] arrayOfLines, int[] arrayOfScores, String[] arrayOfNames) {

    String[] strings;

    for (int i = 0; i < arrayOfLines.length; i++) {
      strings = arrayOfLines[i].split(",");

      // when reading the file it reads in an undisplayable unicode letter
      // this code removes the unicode letters:
      if (i == 0) {
        strings[0] = strings[0].substring(1);
      } 

      arrayOfScores[i]= Integer.parseInt(strings[0]);
      arrayOfNames[i]=strings[1];
    }
  }

  private void sortArrayInReverse (int[] arrayOfScores, String[]arrayOfNames ) {

    for (int j = 0; j < arrayOfScores.length; j++) {
      for (int i = 0; i < arrayOfScores.length-1; i++) {
        if (arrayOfScores[i] < arrayOfScores[i+1]) {

          // bubble sort arrays:
          int tempScore = arrayOfScores[i];
          arrayOfScores[i] = arrayOfScores[i+1];
          arrayOfScores[i+1] = tempScore;

          String tempName = arrayOfNames[i];
          arrayOfNames[i] = arrayOfNames[i+1];
          arrayOfNames[i+1] = tempName;
        }
      }
    }
  }

  private void render() {
    background(255, 255, 255); // wipe background
    textSize(25);
    textAlign(CENTER, CENTER);
    text("Well done " + player1.name + "! ", width/2, height/2-60);
    text("You got a score of: " + int(player1.score) + "! Thank you for playing!", width/2, height/2);
    text("Please close the window.", width/2, height/2+60);
  }

  private void writeScoresToFile(String fileName, String dataToWrite, String[] arrayOfLines, ArrayList<String> lines) {

    // adds array of lines to array list:
    for (int i = 0; i < arrayOfLines.length; i++) {
      lines.add(arrayOfLines[i]);
    }
    lines.add(dataToWrite);

    PrintWriter output = createWriter(fileName);

    // writes array list to file
    for (int i = 0; i < lines.size(); i++) {
      output.println(lines.get(i));
    }
    output.flush(); // flushes all extra data to file
    output.close(); // closes the file writer
  }

  private void renderTopScores(int[] arrayOfScores, String[]arrayOfNames) {

    float lineY;
    float lineSpacing;
    int numberOfLines;
    int totalNumberOfLines;

    if (arrayOfNames.length > 7) {
      numberOfLines = 7;
    } else {
      numberOfLines = arrayOfNames.length;
    }

    totalNumberOfLines = numberOfLines+1;
    lineSpacing = (height / totalNumberOfLines) /2;

    int firstYValue = getFirstYValue(totalNumberOfLines, lineSpacing);
    lineY = firstYValue;

    fill(0);
    textSize(15);
    textAlign(LEFT, CENTER);

    text("Top Scores:", width/15, firstYValue);
    for (int i = 0; i < numberOfLines; i++) {
      lineY = (int) lineY+lineSpacing;
      text(arrayOfScores[i] + ", " + arrayOfNames[i], width/15, lineY);
    }
  }

  private int getFirstYValue (int totalNumberOfLines, float lineSpacing) {
    int middleLine = (int) (totalNumberOfLines/2);
    int linesAboveMiddleLine = totalNumberOfLines - middleLine;
    return linesAboveMiddleLine * (int) lineSpacing;
  }

  private void createNewFileAndScore(String fileName, String dataToWrite) {
    PrintWriter output = createWriter(fileName);
    output.println(dataToWrite);
    output.flush(); // flushes all extra data to file
    output.close(); // closes the file writer
  }
}
