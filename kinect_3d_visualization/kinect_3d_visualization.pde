import org.openkinect.processing.*;
import L3D.*;

// Instanciate kinnect
Kinect2 kinect;

// Instanciate cube;
L3D cube; 

PImage image;

int simulationSize = 32;
int mode = 0;

void setup() {
  size(480, 480, P3D); // start simulation with 3d mode enabled
  
  
  kinect = new Kinect2(this);
  kinect.initDepth();
  //kinect.initRegistered();
  kinect.initDevice();

  image = createImage(simulationSize, simulationSize, RGB);
  image.loadPixels();
  
  cube=new L3D(this); // init cube
}

ArrayList<Integer> getDepthSubset(int x_width, int y_height, int resultSize) {
  int[] depth = kinect.getRawDepth();
  ArrayList<Integer> depthExtract = new ArrayList<Integer>();
  
  int sum = 0;
  int index = 0; 
  int off_x = (kinect.depthWidth - x_width)/2;
  int off_y = (kinect.depthHeight - y_height)/2;
  
  for (int i=off_x; i<kinect.depthWidth-off_x; i++)
  for (int j=off_y; j<kinect.depthHeight-off_y; j++)
  {
    int offset = i + (j * kinect.depthWidth);
    
    sum += depth[offset];
    index ++;
    
    if (index >= x_width/resultSize) {
      depthExtract.add(sum/(x_width/resultSize));
      sum = 0;
      index = 0; 
    }
  }
  
  return depthExtract;
}

void show2D(int size) {
  scale(350/size);
  translate(2, 2);
  
  ArrayList<Integer> depthExtract = getDepthSubset(128, 128, size);
  
  for(int x=0; x<size; x++)
  for (int y=0; y<size; y++)
  {
    float c = map(depthExtract.get(x+(y*size)), 0, 4500, 255, 0);
     image.pixels[y+(x*size)] =  color(c, 0, 0);
  }
  
  image.updatePixels();
  image(image, 0, 0);
}

void showCube() {
  cube.background(0);
  
  ArrayList<Integer> depthExtract = getDepthSubset(128, 128, 8);
  int[] index = {7, 6, 5, 4, 3, 2, 1, 0};
  
  for(int x=0; x<8; x++)
  for (int y=0; y<8; y++)
  {
    float c = map(depthExtract.get(y+(x*8)), 0, 4500, 255, 0);
    int z = round(map(depthExtract.get(y+(x*8)), 500, 3000, 7, 0));
    cube.setVoxel(x, 7-y, z, color(c, 0, 0));
  }
}

void draw() {
  background(0);
  noFill();
  
  if (mode == 0) {
    show2D(simulationSize);
  } else {
    showCube();
  }
  
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    mode = (mode == 1 ? 0 : 1);
  }
}