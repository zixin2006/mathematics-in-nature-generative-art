float a = 3, k = 10, m = 0.2;
float b;
float t;

void setup() {
  size(600, 600, P3D);
  noStroke();
  b = a * (abs(exp(2 * m * PI) - 1) / (exp(2 * m * PI) + 1)) * sqrt(1 + k * k);
}

void draw() {
  background(255);
  t = frameCount / 200.0;
  lights();
  translate(width / 2, height / 2, -200);
  shell1();
}

void shell1() {
  for (float v = 0; v < TWO_PI; v += 0.15) {
    for (float u = 0; u < 9 * PI; u += 0.15) {
      float x = (a + b * cos(v + t) * exp(m * u) * cos(u + t)) + 3 * sin(t + u);
      float y = (a + b * cos(v + t) * exp(m * u) * sin(u + t / 2)) + 3 * sin(t + u);
      float z = (k * a * u / 1.5 + b * sin(v + t) * exp(m * u) + 30 * sin(t));
      pushMatrix();
      translate(x, z, y);
      sphere(1);
      popMatrix();
    }
  }
}

void keyPressed() {
  saveFrame("shell_image_####.png");
}
