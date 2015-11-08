import org.openkinect.processing.*;
import L3D.*;

// Create kinnect object
Kinect2 kinect;

// Create cube object;
L3D cube; 

int inSubsetSize = 256; // size of the subset of the original image to use
int outSideSize = 8; // number of pixels per side on the output

int mode1 = 0; // used to switch between 2D image and cube view
int mode2 = 0; // used to switch between depth and color image

void setup() {
  size(512, 512, P3D); // start simulation with 3d mode1 enabled
  
  // initialize the Kinect and every module that we will use
  kinect = new Kinect2(this);
  kinect.initDepth(); // we need the depth information
  kinect.initVideo(); // as well as the video from the webcam...
  kinect.initRegistered(); // ... but we want the video that is aligned with the depth sensors
  kinect.initDevice(); // finally start the device 
  
  cube=new L3D(this); // init cube
}

void draw() {
  background(0); // set background to black
  lights(); // turn on light
  
  // toggle between 3D and 3D view
  if (mode1 == 0) {
    show2D(inSubsetSize, outSideSize);
  } else {
    showCube();
  }
  
}

/*
* Returns a portion of the original depth image from the kinect. 
* The depth will be expressed as a degree of red.
* Both the size of the input and the ouput image are variable. 
*/
PImage getDepthSubset(int inSideSize, int outSideSize) {
  PImage depth = kinect.getDepthImage();
  depth.loadPixels();
  
  // Create and prepare output image
  PImage pOut = createImage(outSideSize, outSideSize, RGB);
  pOut.loadPixels();
  
  // How many pixels of the input image are necessary to make 
  // the side of one pixel of the output image
  int pxSize = inSideSize/outSideSize;
  
  // the selected portion of the orginal image is selected
  // by only retaining the pixels that fall into a centered square
  // whose side's side is equal to the one provided in the first argument
  int off_x = (kinect.depthWidth - inSideSize)/2;
  int off_y = (kinect.depthHeight - inSideSize)/2;
  depth = depth.get(off_x, off_y, inSideSize, inSideSize);
  
  // loop through areas of the input image and run algorithm to extract 
  // average depth value
  for (int x=0; x<depth.width; x+=pxSize)
  for (int y=0; y<depth.height; y+=pxSize)
  {
    float sum = 0;
    PImage subset = depth.get(x, y, pxSize, pxSize); // get pixels of area of interest
    subset.loadPixels();
    
    // the depth is represented by the brightness value 
    // on the range [0 ; 255]
    for (int k=0; k<subset.pixels.length; k++) {
      sum += brightness(subset.pixels[k])/subset.pixels.length;
    }
    
    int loc = (x/pxSize) + ((y/pxSize)*outSideSize);
    sum = (sum==0 ? 255 : sum); // discard outlying values
    sum = map(sum, 0, 255, 255, 0); // reverse the range
    pOut.pixels[loc] = color(sum, 0, 0); // store as a degree of red in the output image
  }
  
  // reload pixels in output image and return
  pOut.updatePixels();
  return pOut;
}

/*
* Returns a portion of the original color image from the kinect. 
* Both the size of the input and the ouput image are variable. 
*/
PImage getColorSubset(int inSideSize, int outSideSize) {
  PImage colorImg = kinect.getRegisteredImage();
  colorImg.loadPixels();

  PImage pOut = createImage(outSideSize, outSideSize, RGB);
  pOut.loadPixels();
  
  int pxSize = inSideSize/outSideSize;
  
  int off_x = (kinect.depthWidth - inSideSize)/2;
  int off_y = (kinect.depthHeight - inSideSize)/2;
  colorImg = colorImg.get(off_x, off_y, inSideSize, inSideSize);
    
  for (int x=0; x<colorImg.width; x+=pxSize)
  for (int y=0; y<colorImg.height; y+=pxSize)
  { 
    float[] sum = new float[3];
    PImage subset = colorImg.get(x, y, pxSize,pxSize);
    subset.loadPixels();

    for (int k=0; k<subset.pixels.length; k++) {
      sum[0] += red(subset.pixels[k])/subset.pixels.length;
      sum[1] += green(subset.pixels[k])/subset.pixels.length;
      sum[2] += blue(subset.pixels[k])/subset.pixels.length;
    }
    int loc = (x/pxSize) + ((y/pxSize)*outSideSize);
    pOut.pixels[loc] = color(sum[0], sum[1], sum[2]);      
  }
  
  pOut.updatePixels();
  return pOut;
}

/* 
 * Display output image.
 * Either depth or color.
 */
void show2D(int inSize, int outSize) {
  PImage image;
  
  // toggle output image
  if (mode2 == 0) {
    image = getColorSubset(inSize, outSize);
  } else {
    image = getDepthSubset(inSize, outSize);
  }
  
  scale(512/outSize); // scale image object to fill the rendering screen
  image(image, 0, 0); // display output image
}

/* 
* Render voxels on the cube according to their depth and color value taken 
* from the Kinect. 
*/
void showCube() {
  PImage depthImage = getDepthSubset(256, 8); // get depth info
  PImage colorImage = getColorSubset(256, 8); // get color info
  depthImage.loadPixels();
  colorImage.loadPixels();
  
  cube.background(0); // clear cube background
  
  for(int x=0; x<8; x++)
  for (int y=0; y<8; y++)
  {
    // map red value from depth image to a value that falls on the z axis
    int z = round(map(red(depthImage.pixels[y+(x*8)]), 0, 255, 7, 0));
    // display voxel
    cube.setVoxel(x, 7-y, z, colorImage.pixels[y+(x*8)]);
  }
}


/* 
 * Toggle image or cube rendering on right click
 */
void mousePressed() {
  if (mouseButton == RIGHT) {
    mode1 = (mode1 == 1 ? 0 : 1);
  }
}

/* 
 * Toggle depth or color image view if any key is pressed
 */
void keyPressed() {
  mode2 = (mode2 == 1 ? 0 : 1);
}