float[][] points = {
  {100, 600}, {200, 700}, {500, 500}, {200, 500}, 
  {150, 300}, {600, 200}, {650, 300}, {400, 400}, 
  {500, 100}, {400, 130}, {600, 300}, {500, 700}
};
float a = 0.69;
float[][] interpoints;

void setup() {
  size(800, 800);
  background(255);
  render();
}

float[] pinterpolate(float[][] ps, float[] ws) {
  float[] ret = {0, 0};
  for (int i = 0; i < ps.length; i++) {
    ret[0] += ps[i][0] * ws[i];
    ret[1] += ps[i][1] * ws[i];
  }
  return ret;
}

float[][] subdivide(float[][] arr) {
  ArrayList<float[]> ret = new ArrayList<float[]>();
  int rl = arr.length;
  
  ret.add(arr[0]);
  ret.add(pinterpolate(new float[][] {arr[0], arr[0], arr[1], arr[2]}, new float[] {0.5 - a, a, a, 0.5 - a}));
  
  for (int i = 1; i < rl - 2; i++) {
    ret.add(arr[i]);
    ret.add(pinterpolate(new float[][] {arr[i - 1], arr[i], arr[i + 1], arr[i + 2]}, new float[] {0.5 - a, a, a, 0.5 - a}));
  }
  
  ret.add(arr[rl - 2]);
  ret.add(pinterpolate(new float[][] {arr[rl - 3], arr[rl - 2], arr[rl - 1], arr[rl - 1]}, new float[] {0.5 - a, a, a, 0.5 - a}));
  ret.add(arr[rl - 1]);

  float[][] result = new float[ret.size()][2];
  ret.toArray(result);
  return result;
}

void render() {
  noStroke();
  fill(255, 0, 0);
  for (float[] p : points) {
    ellipse(p[0], p[1], 16, 16);
  }
  
  interpoints = points;
  for (int i = 0; i < 9; i++) {
    interpoints = subdivide(interpoints);
  }
  
  fill(0);
  for (float[] p : interpoints) {
    ellipse(p[0], p[1], 2, 2);
  }
   save("fractal_pattern.png"); 
}

void draw() {
  // static rendering only
}
