int cols, rows;
int scl = 20;
float zoff = 0;
float scaleSpeed = 0.01;
color lineColor;
String[] flowDirections = {"horizontal", "vertical", "diagonal"};
int currentFlowDirection = 0;

void setup() {
  size(1000, 900);
  cols = floor(width / scl);
  rows = floor(height / scl);
  lineColor = color(0);
  
  createControlButtons();
}

void draw() {
  background(255);
  float yOffset = 0;
  for (int y = 0; y < rows; y++) {
    float xOffset = 0;
    for (int x = 0; x < cols; x++) {
      float angle = 0; // Initialize angle with a default value
      if (flowDirections[currentFlowDirection].equals("horizontal")) {
        angle = noise(xOffset, yOffset, zoff) * TWO_PI;
      } else if (flowDirections[currentFlowDirection].equals("vertical")) {
        angle = noise(yOffset, xOffset, zoff) * TWO_PI;
      } else if (flowDirections[currentFlowDirection].equals("diagonal")) {
        angle = noise(xOffset, xOffset, zoff) * TWO_PI;
      }
      PVector v = PVector.fromAngle(angle);
      stroke(lineColor);
      strokeWeight(2);
      pushMatrix();
      translate(x * scl, y * scl);
      rotate(v.heading());
      line(0, 0, scl, 0);
      popMatrix();
      xOffset += 0.1;
    }
    yOffset += 0.1;
  }
  zoff += scaleSpeed;
}

// Buttons creation
void createControlButtons() {
  println("Controls:");
  println("'1' - Increase Scale Speed");
  println("'2' - Decrease Scale Speed");
  println("'3' - Change Line Color");
  println("'4' - Change Flow Direction");
}

void keyPressed() {
  if (key == '1') {
    increaseScaleSpeed();
  } else if (key == '2') {
    decreaseScaleSpeed();
  } else if (key == '3') {
    changeLineColor();
  } else if (key == '4') {
    changeFlowDirection();
  }
}

void increaseScaleSpeed() {
  scaleSpeed += 0.005;
}

void decreaseScaleSpeed() {
  scaleSpeed -= 0.005;
  scaleSpeed = max(scaleSpeed, 0);
}

void changeLineColor() {
  lineColor = color(random(255), random(255), random(255));
}

void changeFlowDirection() {
  currentFlowDirection = (currentFlowDirection + 1) % flowDirections.length;
}
