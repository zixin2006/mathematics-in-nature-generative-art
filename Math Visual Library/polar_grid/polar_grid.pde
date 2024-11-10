int gridWidth = 9;
int gridHeight = 5;
int squareSize = 80;
ArrayList<GridItem> grid = new ArrayList<>();
float radius = 8;

void setup() {
  size(900, 600);
  float offsetX = (width - (gridWidth * squareSize)) / 2;
  float offsetY = (height - (gridHeight * squareSize)) / 2;
  
  // Create grid and add Flowers and Butterflies
  for (int x = 0; x < gridWidth; x++) {
    for (int y = 0; y < gridHeight; y++) {
      float xPos = x * squareSize + offsetX;
      float yPos = y * squareSize + offsetY;
      
      Flower f = new Flower(xPos, yPos, radius);
      grid.add(f);
      
      if (random(1) < 0.05) {
        Butterfly b = new Butterfly(xPos, yPos, radius);
        grid.add(b);
        grid.removeIf(item -> item instanceof Flower && item.xPos == xPos && item.yPos == yPos);
      }
    }
  }
}

void draw() {
  background(255);

  // Show items in grid
  for (GridItem item : grid) {
    item.show();
  }
}

void mouseClicked() {
  for (GridItem item : grid) {
    item.checkClick(mouseX, mouseY);
  }
}

// Abstract class for grid items
abstract class GridItem {
  float xPos, yPos, radius;
  float offsetX, offsetY;
  boolean clicked;
  float centerX, centerY;

  GridItem(float xPos, float yPos, float radius) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.radius = radius;
    this.centerX = xPos + squareSize / 2;
    this.centerY = yPos + squareSize / 2;
    this.clicked = false;
  }

  abstract void show();
  abstract void checkClick(float px, float py);
}

class Flower extends GridItem {
  float deg;

  Flower(float xPos, float yPos, float radius) {
    super(xPos, yPos, radius);
    deg = random(0, 360);
  }

  void checkClick(float px, float py) {
    float d = dist(px, py, centerX, centerY);
    if (d < squareSize / 2) {
      clicked = !clicked;
    }
  }

  void show() {
    noFill();
    if (clicked) {
      offsetX = 0;
      offsetY = 0;
      stroke(0, 120, 255);
    } else {
      offsetX = map(mouseX, xPos, xPos + squareSize, -0.5, 0.5);
      offsetY = map(mouseY, yPos, yPos + squareSize, -0.5, 0.5);
      stroke(0, 120, 255, 255 - 0.3 * dist(centerX, centerY, mouseX, mouseY));
    }
    push();
    translate(centerX, centerY);
    ellipse(0, 0, 7, 7);
    rotate(deg);
    beginShape();
    for (float theta = 0; theta < 360; theta += 1) {
      float offX = map(sin(5 * theta) + offsetX * cos(noise(cos(radians(theta))) * theta), -1, 1, -4, 4);
      float offY = map(sin(5 * theta) + offsetY * sin(noise(sin(radians(theta))) * theta), -1, 1, -4, 4);
      float x = radius * offX * cos(theta);
      float y = radius * offY * sin(theta);
      vertex(x, y);
    }
    endShape(CLOSE);
    pop();
  }
}

class Butterfly extends GridItem {

  Butterfly(float xPos, float yPos, float radius) {
    super(xPos, yPos, radius - 1);
  }

  void checkClick(float px, float py) {
    float d = dist(px, py, centerX, centerY);
    if (d < squareSize / 2) {
      clicked = !clicked;
    }
  }

  void show() {
    if (clicked) {
      offsetX = 0;
      offsetY = 0;
      stroke(0, 120, 255);
    } else {
      offsetX = map(mouseX, xPos, xPos + squareSize, -0.5, 0.5);
      offsetY = map(mouseY, yPos, yPos + squareSize, -0.5, 0.5);
      stroke(0, 120, 255, 255 - 0.3 * dist(centerX, centerY, mouseX, mouseY));
    }
    push();
    translate(centerX, centerY);
    rotate(0);
    beginShape();
    for (float theta = 0; theta < 360; theta += 1) {
      float offX = map(sin(5 * theta) + offsetX * cos(noise(cos(radians(theta))) * theta), -1, 1, -4, 4);
      float offY = map(sin(5 * theta) + offsetY * sin(noise(sin(radians(theta))) * theta), -1, 1, -4, 4);
      float butterfly = (exp(sin(radians(theta))) - 2 * cos(4 * radians(theta)) + pow(sin(radians(theta) / 12), 5)) * radius / 2;
      float x = offX * butterfly * cos(theta);
      float y = offY * butterfly * sin(theta);
      vertex(x, y);
    }
    endShape(CLOSE);
    pop();
  }
}
