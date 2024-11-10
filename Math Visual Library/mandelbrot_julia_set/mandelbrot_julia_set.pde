void setup() {
  size(600, 600);
  background(255);
  noLoop();
}

void draw() {
  for (int x = 0; x < 600; x++) {
    for (int y = 0; y < 600; y++) {
      
      // Convert canvas x, y to complex number c = a + bi
      float a = -0.9777837079344034;
      float b = -0.2564440536838108;
      
      float z_real = map(x, 0, 599, -1.7, 1.7);
      float z_imag = map(y, 0, 599, 1.7, -1.7);
      
      int iteration = 1;
      while (iteration <= 500 && dist(0, 0, z_real, z_imag) < 2) {
        // z^2 + c function
        float z_real_temp = (z_real * z_real) - (z_imag * z_imag) + a;
        float z_imag_temp = (2 * z_real * z_imag) + b;
        z_real = z_real_temp;
        z_imag = z_imag_temp;
        iteration++;
      }
      

      if (iteration == 501) {
        stroke(0, 0, 0); // Black for points inside the set
      } else {
        float fraction = (float)Math.tanh(iteration / 100.0);
        color col_1 = color(255, 255, 255);
        color col_2 = color(0, 0, 50);
        stroke(lerpColor(col_1, col_2, fraction));
      }
      point(x, y);
    }
  }
  save("mandelbrot_fractal.png");
}
