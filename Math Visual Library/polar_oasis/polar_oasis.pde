float noiE = 55;
float noiE_r = 30;
float dTheta = 0.1;
float aR = 0.1;
float exponent = 1.0 / 2;

float theta;
float r;
color colB;
float rand;
int seed;

void setup() {
  size(900, 900);
  background(250);
  colB = color(35, 95, 75, 100);
  theta = 1;
  r = aR * theta;
  rectMode(CENTER);
  rand = random(TWO_PI);
  seed = int(1000000 * random(1));
  noiseSeed(seed);
}

void draw() {
  r = aR * theta;
  
  pushMatrix();
  translate(width / 2, height / 2);
  rotate(rand);
  
  for (int i = 0; i < 600; i++) {
    if (i > 300) r = aR * theta;

    if (r > min(width, height) / 2 * 0.9) noLoop();

    float x = r * cos(theta);
    float y = r * sin(theta);
    float noi = noise(10000 + x / noiE, 10000 + y / noiE, r / noiE_r);

    drawDot(noi, x, y);
    theta += dTheta / sqrt(r);
  }
  popMatrix();
  
  textAlign(LEFT, TOP);
  textSize(14);
  fill(153);
  text("seed: " + seed, 10, 10);
  
  textAlign(RIGHT, TOP);
  textSize(10);
  fill(153);
  text("[click] re-draw     [shift + click] save image", width - 10, 10);
}

void drawDot(float noiV, float x, float y) {
  float threshold = map(dist(x, y, 0, 0), 0, min(width, height) / 2, 0, 1);
  threshold = pow(threshold, exponent);
  threshold = map(threshold, 0, 1, 0, 0.7);
  
  if (noiV < threshold) return;
  
  float noiC = noise(x / 20, y / 20, threshold - noiV);
  fill(
    155 - 150 * noiC,
    175 - 80 * noiC,
    165 - 100 * noiC,
    100
  );
  noStroke();
  ellipse(x, y, 3, 3);
}

void mousePressed() {
  if (keyPressed && key == CODED && keyCode == SHIFT) {
    save("map.png");
  } else {
    setup();
    loop();
  }
}

void touchStarted() {
  setup();
  loop();
}
