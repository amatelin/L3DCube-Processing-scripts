import L3D.*;

L3D cube;
int radius = 4;
PVector center;


PVector[] polarCoord = {new PVector(51.507222, -0.1275), // London
  new PVector(48.8567, 2.3508), // Paris
  new PVector(40.4000, -3.7167), // Madrid
  new PVector(55.7500, 37.6167), // Moscow
  new PVector(45.5017, -73.5673), // Montreal
  new PVector(41.8369, -87.6847), // Chicago
  new PVector(40.7127, -87.6847), // NYC
  new PVector(34.05, -118.25), // LA
  new PVector(39.9167, 116.3833), // Beijing
  new PVector(-23.5500, -46.6333), // Sao Paulo
  new PVector(-26.2044, 28.0456)}; // Johannesburg 

PVector[] cartesCoord = new PVector[11];


void setup() {
  size(800, 800, P3D);
  cube = new L3D(this);
  //cube.enableMulticastStreaming(2000);
  
  processCoordinates(radius);
  plotCoordinates();

}


void draw() {
  scale(2);
  translate(-200, -200, 0);
  background(0);
  lights();
  
  //this.translate(this.width, this.height);
  //this.rotateY((float)90);
}

color processColor(float value) {
  color c1 = color(99,184, 255);
  color c2 = color(   255, 97,3);
  int maxTemp = 60;
  int minTemp = -60;
  float inter = map(value, maxTemp, minTemp, 0, 1);
   
  color c = lerpColor(c1, c2, inter);
   
  return c;
}

void plotCoordinates() {
  for (int i=0; i<cartesCoord.length; i++) {
    try {
      cube.setVoxel(cartesCoord[i], color(random(255), random(255), random(255)));
    } catch(NullPointerException e) {
    
    }; 
  }
}

void processCoordinates(int radius) {
  println(polarCoord.length);
  for (int i=0; i<polarCoord.length; i++) {
    println(i);
    cartesCoord[i] = projectCoordinates(polarCoord[i].x, polarCoord[i].y, radius);
  }
}

PVector projectCoordinates(float latitude, float longitude, float r) {
  float theta = (latitude*PI)/180;
  float phi = (longitude*PI)/180;
  float x = (cos(phi)*cos(theta)*r)+4;
  float y = (sin(phi)*cos(theta)*r)+4;
  float z = (sin(theta)*r)+4;
  
  return new PVector(floor(x), floor(y), floor(z));
}