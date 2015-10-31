import org.openkinect.processing.*;
import L3D.*;

// Instanciate kinnect
Kinect2 kinect;

// Instanciate cube;
L3D cube; 

PImage image;



void setup() {
  size(480, 480, P3D); // start simulation with 3d mode enabled
  
  
  kinect = new Kinect2(this);
  kinect.initDepth();
  //kinect.initRegistered();
  kinect.initDevice();

  //image = new PImage(kinect.depthWidth, kinect.depthHeight);
  
  cube=new L3D(this); // init cube
}

void draw() {
  cube.background(0);
  background(0);
  noFill();
  
  //image = kinect.getDepthImage();
  //image(image, 0, 0);
  int[] depth = kinect.getRawDepth();
  int[] depthExtract = new int[4096];
  int[] projection = new int[64];
  
  for (int i=223; i<(223+64); i++)
  for (int j=179; j<(179+64); j++)
  {
    if (depth[i*j]>100&&depth[i*j]<3000) {
      depthExtract[(i-223)*(j-179)] = depth[i*j];
    } else {
      depthExtract[(i-223)*(j-179)] = -1;
    }
  }
  
  int loc=0;
  for(int x=0; x<64; x+=8)
  for (int y=0; y<64; y+=8)
  {
   
   if (depthExtract[x*y]!=-1) {
     projection[loc] = round(map(depthExtract[x*y], 0, 4050, 7, 0));
   } else {
     projection[loc] = -1;
   }
   
   
   println(projection[loc]);
   
   cube.setVoxel((x/8), (y/8), projection[loc], color(255, 0, 0));
   loc++;
  }

}