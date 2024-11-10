int offset, margin, cells;
float d;

void setup() {
  size(800, 800);
  colorMode(HSB, 360, 100, 100, 100);
}

void draw() {
  background(0, 0, 10);

  cells = int(random(1, 18));
  offset = width / 15;
  margin = offset / 3;
  d = (width - offset * 2 - margin * (cells - 1)) / cells;

  stroke(0, 0, 100);
  strokeWeight(3);
  noFill();
  int prev_shape_num = -1;
  int shape_num = -1;

  for (int j = 0; j < cells; j++) {
    for (int i = 0; i < cells; i++) {
      float x = offset + i * (d + margin) + d / 2;
      float y = offset + j * (d + margin) + d / 2;
      while (prev_shape_num == shape_num) {
        shape_num = int(random(12));
      }
      drawFancyShape(x, y, d, shape_num);
      prev_shape_num = shape_num;
    }
  }

  noLoop();
}

void drawFancyShape(float cx, float cy, float d, int shape_num) {
  pushMatrix();
  translate(cx, cy);
  rotate(int(random(4)) * 360 / 4);
  switch (shape_num) {
    case 0:
      ellipse(0, 0, d, d);
      break;
    case 1:
      arc(0, 0, d, d, 0, 270);
      break;
    case 2:
      beginShape();
      for (float angle = -90; angle < 90; angle++) {
        vertex(cos(radians(angle)) * d / 2, sin(radians(angle)) * d / 2);
      }
      vertex(-d / 2, d / 2);
      endShape(CLOSE);
      break;
    case 3:
      beginShape();
      for (float angle = -90; angle < 90; angle++) {
        vertex(cos(radians(angle)) * d / 2, sin(radians(angle)) * d / 2);
      }
      vertex(-d / 2, d / 2);
      vertex(-d / 2, -d / 2);
      endShape(CLOSE);
      break;
    case 4:
      rectMode(CENTER);
      rect(0, 0, d, d);
      break;
    case 5:
      beginShape();
      vertex(d / 2, -d / 2);
      vertex(d / 2, d / 2);
      vertex(-d / 2, d / 2);
      vertex(-d / 2, 0);
      vertex(0, -d / 2);
      endShape(CLOSE);
      break;
    case 6:
      scale(-1, 1);
      beginShape();
      for (float angle = -90; angle < 90; angle++) {
        vertex(cos(radians(angle)) * d / 2, sin(radians(angle)) * d / 2);
      }
      vertex(-d / 2, d / 2);
      endShape(CLOSE);
      break;
    case 7:
      beginShape();
      vertex(d / 2, -d / 2);
      vertex(d / 2, d / 2);
      vertex(-d / 2, d / 2);
      vertex(0, -d / 2);
      endShape(CLOSE);
      break;
    case 8:
      triangle(-d / 2, -d / 2, d / 2, -d / 2, d / 2, d / 2);
      break;
    case 9:
      beginShape();
      for (float angle = -90; angle < 180; angle++) {
        vertex(cos(radians(angle)) * d / 2, sin(radians(angle)) * d / 2);
      }
      vertex(-d / 2, -d / 2);
      endShape(CLOSE);
      break;
    case 10:
      beginShape();
      vertex(0, -d / 2);
      vertex(d / 2, 0);
      vertex(d / 2, d / 2);
      vertex(-d / 2, d / 2);
      vertex(-d / 2, 0);
      endShape(CLOSE);
      break;
    case 11:
      beginShape();
      vertex(0, -d / 2);
      vertex(d / 2, d / 2);
      vertex(-d / 2, d / 2);
      endShape(CLOSE);
      break;
  }
  popMatrix();
}
