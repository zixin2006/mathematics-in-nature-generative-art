class Perceptron {
  float[] weights;  
  float c;          

  Perceptron(int n, float c_) {
    weights = new float[n];
    for (int i = 0; i < weights.length; i++) {
      weights[i] = random(-1,1); 
    }
    c = c_;
  }

  void train(float[] inputs, int desired) {
    int guess = feedforward(inputs);
    float error = desired - guess;
    for (int i = 0; i < weights.length; i++) {
      weights[i] += c * error * inputs[i];         
    }
  }

  int feedforward(float[] inputs) {
    float sum = 0;
    for (int i = 0; i < weights.length; i++) {
      sum += inputs[i] * weights[i];
    }
    return activate(sum);
  }
  
  int activate(float sum) {
    if (sum > 0) return 1;
    else return -1; 
  }
  
  float[] getWeights() {
    return weights; 
  }
}

class Trainer {
  
  float[] inputs;
  int answer; 
  
  Trainer(float x, float y, int a) {
    inputs = new float[3];
    inputs[0] = x;
    inputs[1] = y;
    inputs[2] = 1;
    answer = a;
  }
}

Trainer[] training = new Trainer[2000];
Perceptron ptron;

int count = 0;

float xmin = -400;
float ymin = -100;
float xmax =  400;
float ymax =  100;

float f(float x) {
  return 0.4 * x + 1;
}

void setup() {
  size(640, 360);
  ptron = new Perceptron(3, 0.00001);

  for (int i = 0; i < training.length; i++) {
    float x = random(xmin, xmax);
    float y = random(ymin, ymax);
    int answer = 1;
    if (y < f(x)) answer = -1;
    training[i] = new Trainer(x, y, answer);
  }
  smooth();
}

void draw() {
  background(255);
  translate(width/2, height/2);

  strokeWeight(4);
  stroke(127);
  float x1 = xmin;
  float y1 = f(x1);
  float x2 = xmax;
  float y2 = f(x2);
  line(x1, y1, x2, y2);

  stroke(0);
  strokeWeight(1);
  float[] weights = ptron.getWeights();
  x1 = xmin;
  y1 = (-weights[2] - weights[0] * x1) / weights[1];
  x2 = xmax;
  y2 = (-weights[2] - weights[0] * x2) / weights[1];
  line(x1, y1, x2, y2);

  ptron.train(training[count].inputs, training[count].answer);
  count = (count + 1) % training.length;

  for (int i = 0; i < count; i++) {
    stroke(0);
    strokeWeight(1);
    fill(0);
    int guess = ptron.feedforward(training[i].inputs);
    if (guess > 0) noFill();

    ellipse(training[i].inputs[0], training[i].inputs[1], 8, 8);
  }
}

void mousePressed() {
  String filename = "perceptron_" + day() + "-" + month() + "-" + year() + "_" + hour() + "-" + minute() + "-" + second() + ".png";
  save(filename);
}
