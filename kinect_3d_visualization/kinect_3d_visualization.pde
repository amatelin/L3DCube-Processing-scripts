import org.openkinect.processing.*;
import L3D.*;

// Instanciate kinnect
Kinect2 kinect;

// Instanciate cube;
L3D cube; 

PImage image;



void setup() {
  size(512, 424); // start simulation with 3d mode enabled
  
  
  kinect = new Kinect2(this);
  kinect.initDepth();
  //kinect.initRegistered();
  kinect.initDevice();

  //image = new PImage(40, 40);
  image = createImage(kinect.depthWidth, kinect.depthHeight, RGB);
  image.loadPixels();
  
  //cube=new L3D(this); // init cube
}

void draw() {
  //cube.background(0);
  background(0);
  noFill();
    scale(3);
   translate(-170,-140);

  
  //image = kinect.getDepthImage();
  //image(image, 0, 0);
  int[] depth = kinect.getRawDepth();
  //int[] depthExtract = new int[160000];
  ArrayList<Integer> depthExtract = new ArrayList<Integer>();
  int[] projection = new int[64];
  
  int index = 0;
  int sum = 0;  int w1 = 400;
  int off_x = 192;
  int off_y = 148;
  
  for (int i=off_x; i<kinect.depthWidth-off_x; i++)
  for (int j=off_y; j<kinect.depthHeight-off_y; j++)
  {
    int offset = i + (j * kinect.depthWidth);
    float c = map(depth[offset], 0, 4500, 0, 255);

    image.pixels[offset] = color(c, 0, 0);
    //depthExtract.add(depth[i+(j*w1)]);
    //sum += depth[i+(j*w1)];
    //index++;
    
    //if (index>=1) {
    //  depthExtract.add(sum/1);
    //  index=0;
    //  sum=0;
    //  //depthExtract[(i-55)*(j-18)-(10*index)] = sum/10;
    //}
    //if (depth[i*j]>10&&depth[i*j]<2000) {
    //  depthExtract[(i-55)*(j-18)] = depth[i*j];
    //} else {
    //  depthExtract[(i-55)*(j-18)] = -1;
    //}
  }
  
  //int loc=0;
  //int w2 = 400;
  //for(int x=0; x<w2; x+=1)
  //for (int y=0; y<w2; y+=1)
  //{
  //  float c = map(depthExtract.get(x+(y*w2)), 0, 4500, 0, 255);
  //  image.pixels[x+(y*w2)] =  color(c, 0, 0);
  // //println(depthExtract[x*y]);
  // //if (depthExtract[x*y]!=-1) {
  // //  projection[loc] = round(map(depthExtract[x*y], 0, 2000, 7, 0));
  // //} else {
  // //  projection[loc] = -1;
  // //}
   
   
  // //println(projection[loc]);
   
  // //cube.setVoxel((x/8), (y/8), projection[loc], color(255, 0, 0));
  // loc++;
  //}

  image.updatePixels();
  image(image, 0, 0);


}