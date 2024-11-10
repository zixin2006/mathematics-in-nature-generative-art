String[] colorPalette = {
  "#a70267",
  "#f10c49",
  "#fb6b41",
  "#f6d86b",
  "#339194"
};
float crystalSize = 150;
int sides = 6;

ArrayList<Crystal> crystals = new ArrayList<Crystal>();

float margin = crystalSize * 0.2;
float padding = crystalSize * 0.2;
float gridBox = padding + crystalSize;
int columns = 5;
int rows = 4;
float startPos = margin + crystalSize / 2 + padding;
float totalX = (gridBox * columns) + startPos * 2;
float totalY = (gridBox * rows) + startPos * 2;

void setup() {
  size((int) totalX, (int) totalY);
  background(255);
  rectMode(CENTER);
  noLoop();
}

void draw() {
  createGridOfCrystals();
  drawGridOfCrystals();
}

void mouseClicked() {
  background(255);
  crystals.clear();
  createGridOfCrystals();
  drawGridOfCrystals();
}

void createGridOfCrystals() {
  for (int x = 0; x <= columns; x++) {
    for (int y = 0; y <= rows; y++) {
      float posX = (x * gridBox) + startPos;
      float posY = (y * gridBox) + startPos;
      crystals.add(new Crystal(posX, posY));
    }
  }
}

void drawGridOfCrystals() {
  for (Crystal singleCrystal : crystals) {
    singleCrystal.render();
  }
}

class Layer {
  int shapes;
  float angle, step, thickness;
  int numberOfSteps, start, stop;
  color layerColor;

  Layer() {
    shapes = randomSelectFromTwo() ? sides : sides * 2;
    angle = 360 / shapes;
    step = (crystalSize / 2) / (randomSelectFromTwo() ? 8 : 10);
    thickness = randomSelectFromTwo() ? 2 : 4;
    strokeWeight(thickness);
    numberOfSteps = (int) (randomSelectFromTwo() ? 8 : 8 * 1.25);
    start = floor(random(0, numberOfSteps - 2));
    stop = floor(random(start + 1, numberOfSteps - 1));
    layerColor = color(unhex(colorPalette[(int) random(colorPalette.length)]));
    stroke(layerColor);
    noFill();
  }
  
  void render() {} // Empty render method to avoid "function does not exist" error
}

class Crystal {
  float x, y;
  ArrayList<Layer> layers = new ArrayList<Layer>();

  Crystal(float posX, float posY) {
    x = posX;
    y = posY;
    for (LayerConstructor layerCon : layerConstructors) {
      if (random(1) > layerCon.weight) {
        layers.add(layerCon.initialise());
      }
    }
  }

  void render() {
    pushMatrix();
    translate(x, y);
    for (Layer layer : layers) {
      layer.render();
    }
    popMatrix();
  }
}

class Circles extends Layer {
  float circleRadius;
  float positionOfCenter;

  Circles() {
    super();
    circleRadius = crystalSize * 0.43;
    positionOfCenter = crystalSize / 2 - circleRadius / 2;
  }

  void render() {
    pushMatrix();
    for (int i = 0; i < sides; i++) {
      ellipse(0, positionOfCenter, circleRadius, circleRadius);
      rotate(360 / sides);
    }
    popMatrix();
  }
}

class Lines extends Layer {
  Lines() {
    super();
  }

  void render() {
    pushMatrix();
    for (int i = 0; i < shapes; i++) {
      line(start * step, 0, stop * step, 0);
      rotate(angle);
    }
    popMatrix();
  }
}

class OuterShape extends Layer {
  OuterShape() {
    super();
  }

  void render() {
    pushMatrix();
    if (randomSelectFromTwo()) {
      ellipse(0, 0, crystalSize, crystalSize);
    } else {
      polygon(0, 0, crystalSize / 2, 6);
    }
    popMatrix();
  }
}

class DottedLines extends Layer {
  DottedLines() {
    super();
  }

  void render() {
    pushMatrix();
    for (int j = 0; j < shapes; j++) {
      for (int i = 1; i < 8; i++) {
        ellipse(0, step * i, 1, 1);
      }
      rotate(angle);
    }
    popMatrix();
  }
}

class InnerShape extends Layer {
  int size;
  int shapeSelector;

  InnerShape() {
    super();
    size = floor(random(1, 4));
    shapeSelector = floor(random(1, 4));
  }

  void render() {
    pushMatrix();
    if (shapeSelector == 1) {
      ellipse(0, 0, size * step, size * step);
    } else if (shapeSelector == 2) {
      polygon(0, 0, size * step, 6);
    } else if (shapeSelector == 3) {
      polygon(0, 0, size * step, 12);
    } else {
      polygon(0, 0, size * step, 3);
    }
    popMatrix();
  }
}

class InnerShapes extends Layer {
  int shapeSelector;
  int size;

  InnerShapes() {
    super();
    shapeSelector = floor(random(1, 5));
    size = floor(random(1, 3));
    if (randomSelectFromTwo()) noFill(); else fill(layerColor);
  }

  void render() {
    pushMatrix();
    for (int i = 0; i < sides; i++) {
      if (shapeSelector == 1) {
        ellipse(0, start * step, size * step, size * step);
      } else if (shapeSelector == 2) {
        rect(0, start * step, size * step, size * step);
      } else if (shapeSelector == 3) {
        polygon(0, start * step, size * step, 3);
      } else {
        polygon(0, start * step, size * step, 6);
      }
      rotate(360 / sides);
    }
    popMatrix();
  }
}

class InnerHexagonLines extends Layer {
  InnerHexagonLines() {
    super();
  }

  void render() {
    for (int i = 3; i <= 8; i++) {
      polygon(0, 0, i * step, 6);
    }
  }
}

class InnerCircleLines extends Layer {
  InnerCircleLines() {
    super();
  }

  void render() {
    for (int i = 0; i < 8; i++) {
      ellipse(0, 0, i * step * 2, i * step * 2);
    }
  }
}

boolean randomSelectFromTwo() {
  return random(1) > 0.5;
}

void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

class LayerConstructor {
  String name;
  float weight;

  LayerConstructor(String name, float weight) {
    this.name = name;
    this.weight = weight;
  }

  Layer initialise() {
    if (name.equals("outerShape")) return new OuterShape();
    if (name.equals("innerShape")) return new InnerShape();
    if (name.equals("innerHexagonLines")) return new InnerHexagonLines();
    if (name.equals("innerCircleLines")) return new InnerCircleLines();
    if (name.equals("innerShapes")) return new InnerShapes();
    if (name.equals("innerLines")) return new Lines();
    if (name.equals("innerDottedLines")) return new DottedLines();
    if (name.equals("innerCircles")) return new Circles();
    return null;
  }
}

LayerConstructor[] layerConstructors = {
  new LayerConstructor("outerShape", 0.3),
  new LayerConstructor("innerShape", 0.5),
  new LayerConstructor("innerHexagonLines", 0.8),
  new LayerConstructor("innerCircleLines", 0.8),
  new LayerConstructor("innerShapes", 0.4),
  new LayerConstructor("innerLines", 0.3),
  new LayerConstructor("innerDottedLines", 0.3),
  new LayerConstructor("innerCircles", 0.3)
};
