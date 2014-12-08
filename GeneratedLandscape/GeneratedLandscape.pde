// Modified from the sketch "M_1_4_01" in the book "Generative Gestaltung".

//mesh drawing
int tileCount = 50;
int zScale = 150;

//noise
int noiseXRange = 10;
int noiseYRange = 10;
int octaves = 4;
float falloff = 0.5;

//mouse interaction and view settings
int offsetX = 0, offsetY = 0, clickX = 0, clickY = 0, zoom = -280;
float rotationX = 0, rotationZ = 0, targetRotationX = -PI/3, targetRotationZ = 0, clickRotationX, clickRotationZ; 
float rotY = 0;

void setup() {
  size(800, 800, P3D);
}

void draw() {
  noStroke();
  background(255);

//lighting
ambientLight(51, 102, 126);
directionalLight(126, 126, 126, 0, 0, -1);

//view
  pushMatrix();
  translate(width*0.5, height*0.5, 0);
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
      float z1 = noise(noiseX, noiseY);
      float z2 = noise(noiseX, noiseY+noiseStepY);

      vertex(x, y, z1*zScale);   
      vertex(x, y+tileSizeY, z2*zScale);
    }
    endShape();
  }
  popMatrix();
  
//move camera around z-axis
  targetRotationZ += 0.01;
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
}

