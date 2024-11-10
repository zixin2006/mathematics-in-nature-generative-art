int resolution = 100;
float numberOfPoints;
int colorMode = 3;
int n;
float powerOfZ;

// This sets the size that defines the Mandelbrot set. 
// Any points that stay with a size under 1 after iteration are in this fractal.
float escapeRadius = 1;

boolean resButtonClicked = false;

float aAccumulation;
float bAccumulation;

// These variables keep track of the width and height of the virtual window
float minWindowX = -2;
float maxWindowX = 2;
float minWindowY = -2;
float maxWindowY = 2;
float centerX = 0;
float centerY = 0;

void setup() {
  colorMode(HSB, 100);
  size(700, 750);
  background(0, 0, 100);
  drawFractal();
}

void draw() {
  drawUI();
}

void calculatePowerSeries(float cA, float cB) {
  n = 1;
  float a = cA;
  float b = cB;

  aAccumulation = 0;
  bAccumulation = 0;

  float r = sqrt(a * a + b * b);
  float theta = 0;

  // Determine the angle (theta) based on the quadrant of a and b
  if (a > 0) {
    theta = atan(b / a);
  } else if (a < 0) {
    theta = atan(b / a) + PI;
  } else {
    theta = 0;
  }

  // Iterate and apply De Moivre's Theorem
  while (n < resolution) {
    a = cA;
    b = cB;

    powerOfZ = n * n;

    a = pow(r, powerOfZ) * cos(powerOfZ * theta);
    b = pow(r, powerOfZ) * sin(powerOfZ * theta);

    a /= (float) (n * n);
    b /= (float) (n * n);

    aAccumulation += a;
    bAccumulation += b;

    n++;
  }
}

void drawFractal() {
  numberOfPoints = min(10000, 10000 / (maxWindowX - minWindowX));
  if (!resButtonClicked) {
    resolution = round(200 / (maxWindowX - minWindowX));
    resButtonClicked = false;
  }
  background(0, 0, 100);

  boolean first = true;
  float oldX = map(1, minWindowX, maxWindowX, 0, width);
  float oldY = map(0, minWindowY, maxWindowY, height, 50);

  // Plot the fractal points around the escape radius
  for (float t = 0; t < TWO_PI; t += TWO_PI / numberOfPoints) {
    float a = escapeRadius * cos(t);
    float b = escapeRadius * sin(t);

    calculatePowerSeries(a, b);

    float x = map(aAccumulation, minWindowX, maxWindowX, 0, width);
    float y = map(bAccumulation, minWindowY, maxWindowY, height, 50);

    if (first) {
      oldX = x;
      oldY = y;
      first = false;
    }

    stroke(100, 100, 0);
    line(x, height - y, oldX, height - oldY);
    oldX = x;
    oldY = y;
  }
}

void mouseClicked() {
  int mx = mouseX;
  int my = mouseY;

  // Resolution Buttons
  if (mx >= 256 && mx <= 331 && my > (height - 54) && my < (height - 34)) {
    resolution += 100;
    numberOfPoints *= 2;
    resButtonClicked = true;
  }

  if (mx >= 256 && mx <= 331 && my > (height - 21) && my < height) {
    resolution -= 100;
    resButtonClicked = true;
  }

  // Change escape radius
  if (mx >= 441 && mx <= 516 && my > (height - 54) && my < (height - 34)) {
    escapeRadius += 1.0 / 16;
    escapeRadius = min(escapeRadius, 1);
  }
  if (mx >= 441 && mx <= 516 && my > (height - 17) && my < height) {
    escapeRadius -= 1.0 / 16;
  }

  // Reset All Button
  if (mx >= 544 && mx <= 619 && my >= (height - 54) && my < height) {
    escapeRadius = 1.0;
    resolution = 100;
    colorMode = 0;
    minWindowX = -2;
    maxWindowX = 2;
    minWindowY = -2;
    maxWindowY = 2;
    centerX = 0;
    centerY = 0;
  }

  if (my < (height - 50)) {
    float windowWidth = maxWindowX - minWindowX;
    float windowHeight = abs(maxWindowY - minWindowY);

    centerX = (float) mx / width * windowWidth - windowWidth / 2 + centerX; 
    centerY = (float) (height - my - 50) / (height - 50) * windowHeight - windowHeight / 2 + centerY;

    if (mouseButton == LEFT) { // Zoom In
      windowWidth *= 0.5;
      windowHeight *= 0.5;
    } else if (my < (height - 50)) { // Zoom Out
      windowWidth *= 2.0;
      windowHeight *= 2.0;
    }

    minWindowX = centerX - windowWidth / 2;
    maxWindowX = centerX + windowWidth / 2;
    minWindowY = centerY + windowHeight / 2;
    maxWindowY = centerY - windowHeight / 2;
  }
  drawFractal();
}

void drawUI() {
  PFont f = createFont("Arial", 16, true);
  textFont(f, 16);

  fill(0, 100, 0);
  rect(0, height - 55, width, 55);

  // Display Information
  fill(0, 0, 100);
  text("Resolution " + resolution, 3, height - 35);
  text("Window width " + (maxWindowX - minWindowX), 3, height - 5);

  fill(0, 0, 100);
  text("Resolution", 179, height - 21);

  fill(0, 100, 0);
  stroke(0, 0, 100);
  rect(256, height - 54, 75, 20);
  fill(0, 0, 100);
  text("+ 100", 281, height - 39);

  fill(0, 100, 0);
  stroke(0, 0, 100);
  rect(256, height - 17, 75, 16);
  fill(0, 0, 100);
  text("- 100", 281, height - 3);

  fill(0, 0, 100);
  text("Size of domain circle", 357, height - 20);

  fill(0, 100, 0);
  stroke(0, 0, 100);
  rect(441, height - 54, 75, 20);
  fill(0, 0, 100);
  text("+ 0.0625", 458, height - 39);

  fill(0, 100, 0);
  stroke(0, 0, 100);
  rect(441, height - 17, 75, 16);
  fill(0, 0, 100);
  text("- 0.0625", 460, height - 3);

  fill(0, 100, 0);
  stroke(0, 0, 100);
  rect(544, height - 54, 75, 53);
  fill(0, 0, 100);
  text("Reset All", 550, height - 21);
}

void keyPressed() {
  if (key == 't') {
    int res = resolution;
    int w = width;
    int h = height;
    String name = "savedPicture" + day() + "-" + month() + "-" + year() + "-" + hour() + minute() + second() + ".png";
    save(name);
    size(w, h);
    resolution = res;
    println("done saving picture");
  }
}
