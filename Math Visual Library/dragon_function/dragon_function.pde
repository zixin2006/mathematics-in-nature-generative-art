import processing.pdf.*;

int maxLevels = 0; 
float s;

ArrayList<Line> fractal = new ArrayList<Line>();

void setup()
{
  size(900, 900);
  frameRate(100);
}

void draw()
{
  s = width/3.5;
  background(255);
  fractal = new ArrayList<Line>();
  fractal.add(new Line(s, s, s, height-s, 0));
  fractal.add(new Line(s, height-s, width-s, height-s, 0));
  fractal.add(new Line(width-s, height-s, width-s, s, 0));
  fractal.add(new Line(width-s, s, s, s, 0));

  fractate();
  drawFractal();
  //println("done");
  //exit();
}

void mouseClicked()
{
  if (mouseButton == LEFT) {
    maxLevels += 1;
  } else if (maxLevels > 0) {
    maxLevels -= 1;
  }
}


void drawFractal() {
  for (Line l : fractal) {
    l.display();
  }
}


void fractate() {
  int level = 0;
  while (level < maxLevels) {
    if (level % 2 == 0) {
      gosper();
    } else {
      dragon();
    }
    level += 1;
  }
}


void dragon() {
  float turn = PI/4;
  for (int i = fractal.size()-1; i >= 0; i--) {

    Line l = fractal.get(i);


    float angle = atan2((l.y2-l.y1), (l.x2-l.x1));
    float d = dist(l.x1, l.y1, l.x2, l.y2)/2;
    float r = d/cos(turn);
    float nx = l.x1+r*cos(angle + turn);
    float ny = l.y1+r*sin(angle + turn);

    fractal.add(new Line(l.x1, l.y1, nx, ny, l.level + 1));
    fractal.add(new Line(nx, ny, l.x2, l.y2, l.level + 1));        
    fractal.remove(i);

    turn *= -1;
  }
}

void gosper() {
  for (int i = fractal.size ()-1; i >= 0; i--) {
    Line l = fractal.get(i);
    float angle = atan2((l.y2-l.y1), (l.x2-l.x1));
    float d = dist(l.x1, l.y1, l.x2, l.y2);


    float r = d * 1 / sqrt(7);

    float turn1 = -1 * asin(sqrt(3)/(2*sqrt(7))); 
    float turn2 = -1 * PI/3;


    float nx1 = l.x1+r*cos(angle + turn1);
    float ny1 = l.y1+r*sin(angle + turn1);

    float nx2 = nx1 + r*cos(angle + turn1 - turn2);
    float ny2 = ny1 + r*sin(angle + turn1 - turn2);


    fractal.add(new Line(l.x1, l.y1, nx1, ny1, l.level + 1));
    fractal.add(new Line(nx1, ny1, nx2, ny2, l.level + 1));
    fractal.add(new Line(nx2, ny2, l.x2, l.y2, l.level + 1));


    fractal.remove(i);
  }
}

class Line
{
  float x1, x2, y1, y2, r, theta;
  int level, index;

  Line(float x1t, float y1t, float x2t, float y2t, int levelt)
  {
    x1 = x1t;
    y1 = y1t;
    x2 = x2t;
    y2 = y2t;
    level = levelt;
  }

  void display()
  {
    stroke(0);
    strokeWeight(1);
    line(x1, y1, x2, y2);
  }
}
