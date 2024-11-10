int seed = int(random(1000));
float xOff, yOff, dir, plus, wave_h, t;
color[] color1, color2;
color[] colors1 = {color(#7fdeea, 64), color(#a3b7f0, 64), color(#a1e4f7, 64), color(#6d7db6, 64), color(#5a6696, 64)};
color[] colors12 = {color(#7fdeea, 0), color(#a3b7f0, 0), color(#a1e4f7, 0), color(#6d7db6, 0), color(#5a6696, 0)};
color colorbg = color(255);
color colorbg2 = color(255, 26);
PGraphics overAllTexture;

void setup() {
  size(displayWidth, displayHeight);
  color1 = colors1;
  color2 = colors12;
  xOff = -500;
  yOff = 0;
  dir = 1;
  plus = 0.1;
  wave_h = 50;
  t = 0;
  makeFilter();
}

void draw() {
  randomSeed(seed);
  background(colorbg2);
  noStroke();
  float mountain_h = height / int(random(30, 40));

  for (float n = 0; n < height; n += random(mountain_h / 2, mountain_h)) {
    pushMatrix();
    translate(0, height - n);
    PGraphics grad = createGraphics(width, int(mountain_h * 2));
    grad.beginDraw();
    grad.strokeWeight(0);
    grad.beginShape();
    grad.fill(random(color1));
    grad.vertex(-n, n);

    for (float i = xOff; i < width - xOff; i += 100) {
      float p = random(-1, 1);
      grad.vertex(i, cos(radians(i + t)) * p * random(yOff));
    }
    
    grad.vertex(width + n, n);
    grad.endShape(CLOSE);
    grad.endDraw();
    image(grad, 0, -mountain_h);
    popMatrix();
  }

  if (dir == 1) {
    if (yOff < wave_h) {
      dir = 1;
    } else if (yOff >= wave_h) {
      dir = -1;
      plus = random(0.1);
    }
  } else if (dir == -1) {
    if (yOff > 0) {
      dir = -1;
    } else if (yOff <= 0) {
      dir = 1;
      plus = random(0.1);
    }
  }
  
  yOff += plus * dir;
  t += 0.1;
  image(overAllTexture, 0, 0);
}

void makeFilter() {
  colorMode(HSB, 360, 100, 100, 100);
  overAllTexture = createGraphics(width, height);
  overAllTexture.loadPixels();
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      float noiseValue = noise(i / 3.0, j / 3.0, (i * j) / 50.0) * random(5, 15);
      overAllTexture.pixels[i + j * width] = color(0, 0, 99, noiseValue);
    }
  }
  overAllTexture.updatePixels();
}

void keyTyped() {
  if (key == 's' || key == 'S') {
    saveFrame("GENUARY_2022_0113_800x800.png");
  }
}
