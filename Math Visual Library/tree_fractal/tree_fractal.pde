Stick firstStick;
ArrayList<Stick> tree;
int iteration = 0;
float scalefactormax = 0;
float strokeThick = 0;

int itermax = 15;              
float rotatemax = 0.625;            
float growprob = 0.6;          
float splitprob = 0.7;         
int splitmax = 2;              
float scalefactormin = 0.6;   
float scalefactormaxinit = 1.2;   
float scalefactorscale = 0.995;  
float strokeweightinit = 5;    
float strokescale = 0.3;       

void setup() {
  size(650, 700);
  background(255, 255, 255);
  stroke(0, 0, 0);
  strokeThick = strokeweightinit;
  strokeWeight(strokeThick);
  strokeCap(PROJECT);
  scalefactormax = scalefactormaxinit;
  firstStick = new Stick(width/2, height, new PVector(1, random(-120, -40)));
  tree = new ArrayList<Stick>();
  tree.add(firstStick);
  firstStick.display();
}

void draw() {
  if (keyPressed == true) {
    background(255, 255, 255);
    iteration = 0;
    scalefactormax = scalefactormaxinit;
    tree = new ArrayList<Stick>();
    firstStick = new Stick(width/2, height, new PVector(1, random(-120, -40)));
    tree.add(firstStick);
    firstStick.display();
    strokeThick = strokeweightinit;
    strokeWeight(strokeThick);
  }

  if (iteration <= itermax) {
    int end = tree.size();
    for (int i = 0; i < end; i++) {
      float grow = random(1);
      if (grow < growprob) {
        float split = random(1);
        if (split < splitprob) {
          for (int h = 0; h < round(random(1, splitmax)); h++) {
            tree.add(update(tree.get(i)));
            tree.get(tree.size() - 1).display();
          }
        }
        tree.add(update(tree.get(i)));
        tree.get(tree.size() - 1).display();    
        tree.remove(i);
      }
    }
    iteration++;
    strokeThick -= strokescale;
    strokeWeight(strokeThick);
  }
}

Stick update(Stick INstick) {
  Stick out;
  float rotatefactor = random(-rotatemax, rotatemax);
  float scalefactor = random(scalefactormin, scalefactormax);
  scalefactormax = scalefactormax * scalefactorscale;
  PVector dirnew = new PVector(INstick.direction.x, INstick.direction.y);
  dirnew = new PVector(dirnew.x * cos(rotatefactor) - dirnew.y * sin(rotatefactor), dirnew.x * sin(rotatefactor) + dirnew.y * cos(rotatefactor));
  dirnew.mult(scalefactor);
  out = new Stick(INstick.endx, INstick.endy, dirnew);
  return out;
}

class Stick {
  PVector direction;
  float startx;
  float starty;
  float endx;
  float endy;

  Stick(float INstartx, float INstarty, PVector INdirection) {
    direction = INdirection;
    startx = INstartx;
    starty = INstarty;
    endx = INstartx + INdirection.x;
    endy = INstarty + INdirection.y;
  }

  void display() {
    line(startx, starty, endx, endy);
  }
}

void mousePressed() {
  String filename = "tree_image_" + day() + "-" + month() + "-" + year() + "_" + hour() + "-" + minute() + "-" + second() + ".png";
  save(filename);
}
