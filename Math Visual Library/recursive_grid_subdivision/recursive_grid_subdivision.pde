void setup() {
  size(800, 800);
  colorMode(HSB, 100, 100, 100, 100);
}

void draw() {
  background(0, 0, 100);
  separateGrid(0, 0, width);
  frameRate(1);
  noLoop();
}

void separateGrid(float x, float y, float d) {
  int sepNum = int(random(1, 4));
  float w = d / sepNum;
  for (float i = x; i < x + d - 1; i += w) {
    for (float j = y; j < y + d - 1; j += w) {
      if (random(100) < 90 && d > width / 15) {
        separateGrid(i, j, w);
      } else {
        float ww = w - 5;
        int rotate_num = int(random(4)) * 360/4;
        pushMatrix();
        translate(i + w/2, j + w/2);
        rotate(rotate_num);
        drawTrianglePattern(-ww/2, -ww/2, ww, ww);
        popMatrix();
      }
    }
  }
}

void drawTrianglePattern(float _x, float _y, float _w, float _h) {
  strokeWeight(2);
  for (int j = 0; j < _h; j++) {
    for (int i = 0; i < _w; i++) {
      if (i == j || i == _w - 1 - j) {
        point(_x + i, _y + j);
      }
    }
  }
}
