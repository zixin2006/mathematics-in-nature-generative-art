int rowSize = 15;
int marginSize = 6;
int boxSize = 14;
int[] strokes = new int[8];

void setup() {
  size(350, 350);
  noFill();
  stroke(0);
  noLoop();

  for (int i = 0; i < 8; i++) {
    strokes[i] = i;
  }
}

void draw() {
  background(255);

  translate(boxSize * 2, boxSize * 2);

  for (int row = 0; row < rowSize; row++) {
    for (int col = 0; col < rowSize; col++) {
      float x = boxSize * col + marginSize * col;
      float y = boxSize * row + marginSize * row;
      stroke(x, y, 255);

      pushMatrix();
      translate(x, y);
      rect(0, 0, boxSize, boxSize);

      int distFromMiddle = max(abs(row - boxSize / 2), abs(col - boxSize / 2));

      shuffleArray(strokes);
      for (int i = 0; i < distFromMiddle; i++) {
        drawSegment(strokes[i], boxSize, boxSize);
      }
      popMatrix();
    }
  }
  save("tiling_and_tessellation.png");
}

void drawSegment(int i, int w, int h) {
  switch(i) {
    case 0:
      line(0, 0, w, h);
      break;
    case 1:
      line(w, 0, 0, h);
      break;
    case 2:
      line(0, h / 2, w, h / 2);
      break;
    case 3:
      line(0, h / 2, w / 2, 0);
      break;
    case 4:
      line(w / 2, 0, w, h / 2);
      break;
    case 5:
      line(w, h / 2, w / 2, h);
      break;
    case 6:
      line(w / 2, 0, w / 2, h);
      break;
    case 7:
      line(w / 2, h, 0, h / 2);
      break;
  }
}

void shuffleArray(int[] array) {
  int currentIndex = array.length, temporaryValue, randomIndex;

  while (currentIndex != 0) {
    randomIndex = (int) random(currentIndex);
    currentIndex -= 1;

    temporaryValue = array[currentIndex];
    array[currentIndex] = array[randomIndex];
    array[randomIndex] = temporaryValue;
  }
}

void mousePressed() {
  redraw();
}
