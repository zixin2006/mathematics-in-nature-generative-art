Particle[] particles;
float alpha;

void setup() {
  size(1112, 834);
  background(#0A2F8B);
  noStroke(); 
  setParticles();
}

void draw() {
  frameRate(20);
  alpha = map(mouseY, 0, width, 5, 35);
  fill(#0A2F8B, alpha);
  rect(0, 0, width, height);

  loadPixels();
  for (Particle p : particles) {
    p.move();
  }
  updatePixels();
}

void setParticles() {
  particles = new Particle[6000];
  for (int i = 0; i < 6000; i++) { 
    float x = random(height);
    float y = random(height);
    float adj = map(y, 0, height, 900, 0);

    int c = color(255, 255, 255, 255);
    particles[i] = new Particle(x, y, c);
  }
}

void mousePressed() {
  setParticles();
  saveFrame("particle_image-######.png"); // Save the current frame as an image file
}

class Particle {
  float posX, posY, decr, theta;
  color c;

  Particle(float xIn, float yIn, color cIn) {
    posX = xIn;
    posY = yIn;
    c = cIn;
  }

  public void move() {
    update();
    wrap();
    display();
  }

  void update() {
    decr += .008;
    theta = noise(posX * .006, posY * .004, decr) * TWO_PI;
    posX += 300 * cos(theta);
    posY += 3 * sin(theta);
  }

  void display() {
    if (posX > 0 && posX < width && posY > 0  && posY < height) {
      pixels[(int)posX + (int)posY * width] = c;
    }
  }

  void wrap() {
    if (posX < 0) posX = width;
    if (posX > width) posX = 0;
    if (posY < 0) posY = height;
    if (posY > height) posY = 0;
  }
}
