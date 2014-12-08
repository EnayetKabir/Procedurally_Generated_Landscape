// Modified from the sketch "M_1_4_01" in the book "Generative Gestaltung".

//mesh drawing
int tileCount = 50;
int zScale = 150;

//noise
int noiseXRange = 10;
int noiseYRange = 10;
int octaves = 4;
float falloff = 0.5;
float zOff = 0.0;

//mouse interaction and view settings
int offsetX = 0, offsetY = 0, clickX = 0, clickY = 0, zoom = 0;
float rotationX = 0, rotationZ = 0, targetRotationX = -PI/3, targetRotationZ = 0, clickRotationX, clickRotationZ; 
float rotY = 0;

//mesh coloring & animation
float aOff = 0.0;
float bOff = 1000;
float cOff = 100000;
boolean melt = false;
boolean cam = false;
boolean pretty = false;




void setup() {
  size(800, 800, P3D);
}

void draw() {
  noStroke();
  background(255);

  //lighting
  float c1 = map(noise(aOff), 0, 1, 0, 220);
  float c2 = map(noise(bOff), 0, 1, 0, 220);
  float c3 = map(noise(cOff), 0, 1, 0, 255);

  //animate color noise
  if (pretty) {
  aOff += 0.001;
  bOff += 0.001;
  cOff += 0.001;
  }


  ambientLight(c1, c2, c3);
  directionalLight(126, 126, 126, 0, 0, -1);

  //view
  pushMatrix();
  translate(width*0.5, height*0.5, zoom);
  scale(2.3);
  if (mousePressed && mouseButton==RIGHT) {
    offsetX = mouseX-clickX;
    offsetY = mouseY-clickY;
    targetRotationX = min(max(clickRotationX + offsetY/float(width) * TWO_PI, -HALF_PI), HALF_PI);
    targetRotationZ = clickRotationZ + offsetX/float(height) * TWO_PI;
  }
  rotationX += (targetRotationX-rotationX)*0.05; 
  rotationZ += (targetRotationZ-rotationZ)*0.05;
  rotateX(-rotationX);
  rotateZ(-rotationZ); 
  rotateY(rotY);


  //-------------mesh-------------

  if (mousePressed && mouseButton==LEFT) {
    noiseXRange = mouseX/10;
    noiseYRange = mouseY/10;
  }

  noiseDetail(octaves, falloff);

  float tileSizeY = (float)height/tileCount;
  float noiseStepY = (float)noiseYRange/tileCount;

  for (int meshY=0; meshY<=tileCount; meshY++) {
    beginShape(TRIANGLE_STRIP);
    for (int meshX=0; meshX<=tileCount; meshX++) {

      //make the center of the mesh align with origin before translating
      float x = map(meshX, 0, tileCount, -width/2, width/2);
      float y = map(meshY, 0, tileCount, -height/2, height/2);

      float noiseX = map(meshX, 0, tileCount, 0, noiseXRange);
      float noiseY = map(meshY, 0, tileCount, 0, noiseYRange);
      float z1 = noise(noiseX, noiseY, zOff);
      float z2 = noise(noiseX, noiseY+noiseStepY, zOff);

      //
      //      color interColor;
      //      if (z1 <= threshold) {
      //        float amount = map(z1, 0, threshold, 0.15, 1);
      //        interColor = lerpColor(bottomColor, midColor, amount);
      //      } else {
      //        float amount = map(z1, threshold, 0, 0, 1);
      //        interColor = lerpColor(midColor, topColor, amount);
      //      }
      //      fill(interColor);
      vertex(x, y, z1*zScale);   
      vertex(x, y+tileSizeY, z2*zScale);
    }
    endShape();
  }
  popMatrix();

  //move camera around z-axis
  if (cam) {
  targetRotationZ += 0.006;
  }

  //animate mesh
  if (melt) {
    zOff += 0.005;
  }
}

void mousePressed() {
  clickX = mouseX;
  clickY = mouseY;
  clickRotationX = rotationX;
  clickRotationZ = rotationZ;
}

void keyPressed() {
  if (keyCode == UP) falloff += 0.05;
  if (keyCode == DOWN) falloff -= 0.05;
  if (falloff > 0.8) falloff = 0.8;
  if (falloff < 0.0) falloff = 0.0;

  if (keyCode == LEFT) octaves--;
  if (keyCode == RIGHT) octaves++;
  if (octaves < 0) octaves = 0;

  if (key == '+') zoom += 20;
  if (key == '-') zoom -= 20;
}

void keyReleased() {  
  if (key == ' ') noiseSeed((int) random(100000));
  if (key == 'm' || key == 'M') melt = !melt;
  if (key == 'c' || key == 'C') cam = !cam;
  if (key == 'p' || key == 'P') pretty = !pretty;
}

