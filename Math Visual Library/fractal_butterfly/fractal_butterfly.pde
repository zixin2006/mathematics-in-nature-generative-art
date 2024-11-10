float[] x, y, x2, y2;
int ifs = 4;
int iter = 0;
float xmotion = 0;
float ymotion = 0;

void setup() {
  size(800, 800);
  background(255);
  
  rectMode(CENTER);
  ellipseMode(CENTER);
  colorMode(HSB, 360, 255, 255, 1);
  noiseSeed(42);
  noiseDetail(6, 0.85);
  noStroke();
  fill(0, 0, 100, 255);

  x = new float[ifs];
  y = new float[ifs];
  x2 = new float[ifs];
  y2 = new float[ifs];

  for (int i = 0; i < ifs; i++) {
    x[i] = random(0, width);
    y[i] = random(0, height);
    x2[i] = random(0, width);
    y2[i] = random(0, height);
  }
}

PVector f1(float x, float y, int j) {
  return new PVector(y / 2.05, abs(width / 1.5 - x + y / (1.45 * j * ((0.5 - y / width) * 800))));
}

PVector f2(float x, float y, int j) {
  return new PVector((abs(0.5 - j / (float)ifs) * 2.0 * x) / 1 + j * (1 + y / 10), (height / 2 - y * 2 / j + x) / 1.25 + j * (20 - x / 10));
}

PVector f3(float x, float y, int j) {
  return new PVector(abs(width * 0.75 - x * j) / (8 * (j / 4.0) + x / (width / 100)), y / 2.25);
}

PVector f4(float x, float y, int j) {
  return new PVector(y / 2.0, abs(width / 1.5 - x + y / (1.45 * j * ((0.5 - y / width) * 800))));
}

PVector f5(float x, float y, int j) {
  return new PVector((abs(0.5 - j / (float)ifs) * 2.0 * x) / 1 + j * (1 + y / 10), (height / 2 - y * 2 / j + x) / 1.25 + j * (20 - x / 10));
}

PVector f6(float x, float y, int j) {
  return new PVector(abs(width * 0.5 - x * j) / (8 * (j / 6.0) + x / (width / 100)), y / 2.25);
}

PVector[] f = {f1(0, 0, 0), f2(0, 0, 0), f3(0, 0, 0)};
PVector[] ff = {f4(0, 0, 0), f5(0, 0, 0), f6(0, 0, 0)};

void draw() {
  if (iter < 5000000) {
    for (int i = 0; i < 1000; i++) {
      for (int j = 0; j < ifs; j++) {
        int index = floor(random(f.length));
        PVector r = f[index];
        
        x[j] = r.x;
        y[j] = r.y;

        r = ff[index];

        x2[j] = r.x;
        y2[j] = r.y;

        float a = (j / (float)ifs);
        float nx1 = y[j] / height;
        float inx1 = 0.5 + pow(nx1, 3);
        float nx2 = y2[j] / height;
        float inx2 = 0.5 + pow(nx1, 3.5);
        float inx3 = abs(sin(nx1 * PI * 2.9));
        float inx4 = 0.05 + pow(nx1, 1.5);
        float ny1 = abs(0.5 - x[j] / width) * 2;
        float ny = x[j] / width;
        float iny = pow(1 - ny1, 0.5);
        float iny2 = 0.05 + pow(1 - ny1, 0.5);
        float iny3 = 0.25 + abs(sin(ny * PI * 2));

        if (iter > 20) {
          stroke(200 + (i / 1000) + 300 * (iter / 500000), 32 * pow((j / (float)ifs), 2), 0, 0.0125 * a);
          point(width / 2 + x[j] * inx1 * 1.95, height / 1.85 - y[j] * iny);
          point(width / 2 - x[j] * inx1 * 1.95, height / 1.85 - y[j] * iny);
          point(width / 2 + x2[j] * inx2 * 1.15, height / 0.925 - (height / 1.85 - y2[j] * 0.75 * iny2));
          point(width / 2 - x2[j] * inx2 * 1.15, height / 0.925 - (height / 1.85 - y2[j] * 0.75 * iny2));

          stroke(240 + (i / 1000) + 250 * (iter / 500000), 16 * pow((j / (float)ifs), 2), 0, 0.00825 * a);
          point(width / 2 + x[j] * inx4 * 0.25, height / 2.35 - y[j] * 0.25 * iny);
          point(width / 2 - x[j] * inx4 * 0.25, height / 2.35 - y[j] * 0.25 * iny);
          if (y[j] > -height * 0.1 && y[j] < height / 1.5) {
            point(width / 2 + x[j] * inx3 * 0.025, height / 1.705 - y[j] * 0.25);
            point(width / 2 - x[j] * inx3 * 0.025, height / 1.705 - y[j] * 0.25);
          }
        }
      }
      iter++;
    }
  }
}

void generate() {
  noStroke();
  float ystep = 1;

  for (int y = 0; y < height; y += 4) {
    float ny = y / (float)height;
    for (int x = 0; x < width; x += 4) {
      float nx = x / (float)width;
      float n = noise(nx / 12, ny / 12);
      float n2 = noise(nx * 4, ny - 4);
      float yy = height - height / 24 + y - n * height;

      stroke(100 - 60 * pow(ny, 2.25) * (n2 * abs(sin(nx * PI * 0.25 + ny * PI * 8 + 0.25))) + random(-40, 40), 0, 192 + pow(ny, 1) * 68, 0.002);
      line(x + random(-128, 128), yy, x + random(-128, 128), yy - random(32, height));
    }
  }
}
