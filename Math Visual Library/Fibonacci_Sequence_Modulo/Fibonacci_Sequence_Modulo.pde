int N = 14;
int coef = 1;
int sc = 1;
int[] state;

PGraphics gr;

boolean circleMode = true;
boolean squareMode = true;
boolean blackMode = true;
boolean paletteMode = true;
boolean monochromeMode = true;

int paletteSize = 3;
color[] palette;

int totit = 0;

void setup() {
  initStuffs();
}

void mouseClicked() {
  initStuffs();
}

void initStuffs() {
  circleMode = random(1) > 0.33;
  squareMode = random(1) > 0.5;
  blackMode = random(1) > 0.5;
  paletteMode = random(1) > 0.3;
  monochromeMode = random(1) > 0.8;
  N = ceil(exp(0.7 + random(2.8)));
  coef = floor(random(13)) - 6;
  
  int canvasSize = min(width, height) * sc;
  gr = createGraphics(canvasSize, canvasSize);
  
  paletteSize = 2 + floor(random(3));
  palette = new color[paletteSize];
  for (int i = 0; i < paletteSize; i++) palette[i] = newColor();
  
  state = new int[N * N];
  for (int i = 0; i < N * N; i++) state[i] = 0;

  render();
  gr.beginDraw();
  gr.image(gr, 0, 0);
  gr.endDraw();
}

float[] iToCoords(int x, int y) {
  return new float[] {
    width * 0.2 + width * 0.6 * x / (N - 1),
    width * 0.2 + width * 0.6 * y / (N - 1)
  };
}

int[] coordsToI(float x, float y) {
  return new int[] {
    round((x - width * 0.2) * (N - 1) / (width * 0.6)),
    round((y - width * 0.2) * (N - 1) / (width * 0.6))
  };
}

int[] advance(int[] a) {
  return new int[] {
    a[1] % N,
    (a[0] + coef * a[1] + 10 * N) % N
  };
}

float[] interpolatePoint(float[] p1, float[] p2, float t) {
  return new float[] {
    p1[0] * (1 - t) + p2[0] * t,
    p1[1] * (1 - t) + p2[1] * t
  };
}

void iterateFib(int a0, int a1, color c) {
  totit++;
  int iters = 0;
  int[] a = {a0, a1};
  int[] b = advance(a);
  strokeWeight(width / N * 0.12);
  while (true) {
    if (!circleMode) {
      noFill();
      stroke(c);
      line(iToCoords(a[0], a[1])[0], iToCoords(a[0], a[1])[1],
           iToCoords(b[0], b[1])[0], iToCoords(b[0], b[1])[1]);
      stroke(lerpColor(c, color(255, 255, 255), 0.5));
      float[] interp = interpolatePoint(iToCoords(a[0], a[1]), iToCoords(b[0], b[1]), 0.5);
      line(interp[0], interp[1], iToCoords(b[0], b[1])[0], iToCoords(b[0], b[1])[1]);
    } else {
      noStroke();
      fill(c);
      if (!squareMode)
        ellipse(iToCoords(a[0], a[1])[0], iToCoords(a[0], a[1])[1], width / N * 0.5, width / N * 0.5);
      else
        rect(iToCoords(a[0], a[1])[0] - width / (N - 1) * 0.4166, 
             iToCoords(a[0], a[1])[1] - width / (N - 1) * 0.4166, 
             width / (N - 1) * 0.8333, width / (N - 1) * 0.8333);
    }

    state[a[0] + a[1] * N] = 1;
    iters++;
    a = b;
    b = advance(a);
    if (a[0] == a0 && a[1] == a1) break;
  }
}

void draw() {
  if (blackMode)
    background(0, 12, 15);
  else
    background(255, 230, 230);

  image(gr, 0, 0);
  textSize(20);
  stroke(255);
  strokeWeight(4);
  fill(0);
  textFont(createFont("Consolas", 20));

  int[] coords = coordsToI(mouseX, mouseY);
  if (abs(coords[0] - round(coords[0])) < 0.2 && abs(coords[1] - round(coords[1])) < 0.2 && 
      coords[0] >= 0 && coords[0] < N && coords[1] >= 0 && coords[1] < N) {
    text(coords[0] + ", " + coords[1], mouseX + 5, mouseY - 10);
  }
}

color newColor() {
  colorMode(HSB);
  color c;
  if (monochromeMode)
    c = color(0, 0, random(100));
  else if (blackMode)
    c = color(random(360), 88, 78);
  else
    c = color(random(360), 80, 90);
  colorMode(RGB);
  return c;
}

void render() {
  if (blackMode)
    background(18);
  else
    background(250);
  noStroke();
  fill(0);
  if (!circleMode) {
    for (int x = 0; x < N; x++) {
      for (int y = 0; y < N; y++) {
        // ellipse(iToCoords(x, y)[0], iToCoords(x, y)[1], width / N * 0.3, width / N * 0.3);
      }
    }
  }

  for (int x = 0; x < N; x++) {
    for (int y = 0; y < N; y++) {
      if (state[x + y * N] == 0) {
        color c;
        if (paletteMode)
          c = palette[floor(random(paletteSize))];
        else
          c = newColor();
        iterateFib(x, y, c);
      }
    }
  }
}
