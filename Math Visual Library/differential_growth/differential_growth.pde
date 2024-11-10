import java.util.ArrayList;

ArrayList<Node> nodes = new ArrayList<>();
float range;
float maxR;
final float reject = 3;
final float align = 0.18;
final float slow = 0.81;
final float limitVel = 2;

void setup() {
  int m = min(displayWidth, displayHeight);
  size(4 * m / 3, m, P3D);  // Enable 3D renderer
  colorMode(HSB, 255);
  range = m * 0.4;
  maxR = m / 30;
  initialize();
}

void initialize() {
  nodes.clear();
  for (int i = 0; i < 3; i++) {
    float r = random(TWO_PI);
    float d = random(range);
    nodes.add(new Node(new PVector(d * cos(r), d * sin(r)), new PVector(0, 0)));
  }
}

float distance(PVector u, PVector v) {
  return dist(u.x, u.y, u.z, v.x, v.y, v.z);
}

void draw() {
  background(255);
  translate(width / 2, height / 2, 0);  // Center the 3D view
  rotateX(0.5);
  rotate(frameCount / 200.0);
  
  ArrayList<Node> renew = new ArrayList<>();
  for (int i = 0; i < nodes.size(); i++) {
    Node current = nodes.get(i);
    renew.add(current);
    Node next = nodes.get((i + 1) % nodes.size());
    if (distance(current.pos, next.pos) > maxR) {
      PVector midPos = PVector.add(current.pos, next.pos).mult(0.5);
      renew.add(new Node(midPos, new PVector(0, 0)));
    }
  }
  nodes = renew;
  
  for (int i = nodes.size() - 1; i >= 0; i--) {
    Node current = nodes.get(i);
    for (int j = i - 1; j >= 0; j--) {
      Node other = nodes.get(j);
      float d = distance(current.pos, other.pos);
      if (d < maxR && d > 0) {
        PVector delta = PVector.sub(current.pos, other.pos).mult((1 / d - 1 / maxR) * reject);
        current.vel.add(delta);
        other.vel.add(delta.mult(-1));
      }
    }
  }
  
  for (int i = 0; i < nodes.size(); i++) {
    Node prev = nodes.get(i);
    Node current = nodes.get((i + 1) % nodes.size());
    Node next = nodes.get((i + 2) % nodes.size());
    PVector mid = PVector.add(next.pos, prev.pos).mult(0.5);
    PVector dif = PVector.sub(mid, current.pos);
    current.vel.add(dif.limit(align));
  }
  
  for (Node n : nodes) {
    n.pos.add(n.vel.limit(limitVel));
    n.vel.mult(slow);
    n.pos.limit(range);
  }
  
  PVector prev = nodes.get(nodes.size() - 1).pos;
  for (int i = 0; i < nodes.size(); i++) {
    Node node = nodes.get(i);
    pushMatrix();
    stroke(i * 255 / nodes.size(), 255, 240);
    fill(i * 255 / nodes.size(), 60, 240);    
    PVector midPos = PVector.add(prev, node.pos).mult(0.5);
    translate(midPos.x, midPos.y, 0);
    rotateZ(atan2(node.pos.y - prev.y, node.pos.x - prev.x));
    box(distance(prev, node.pos), maxR / 6, maxR / 3);
    popMatrix();
    prev = node.pos;
  }
}

void mousePressed() {
  initialize();
}

void keyPressed() {
  save("img_" + month() + '-' + day() + '_' + hour() + '-' + minute() + '-' + second() + ".jpg");
}

class Node {
  PVector pos;
  PVector vel;
  
  Node(PVector pos, PVector vel) {
    this.pos = pos;
    this.vel = vel;
  }
}
