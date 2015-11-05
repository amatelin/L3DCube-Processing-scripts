import processing.video.*;
import L3D.*;

// Instanciate cube;
L3D cube; 

//Declare objects that will hold our frames
//p holds the original image from the video stream 
//pOut holds the pixels values for the cube
/*
* Declare objects that will hold our frames.
* p holds the original image from the video stream and will store the transformations
* pOut holds the final pixels values (8*8) for the current frame.
*/

Capture video; // webcam stream object

int[][] frames = new int [8][64]; // Array used to store the frames pixels values
int nextFrame = 0; 

boolean enable3d = true; // if set to false, only 1 frame is used.
int updateFrameRate = 5; // if enable3d set to true, frequency at which the past frames are updated

int inSideSize = 512; // Size of the origin image once resized. Must be a multiple of 8. 
int outSideSize = 8;
int mode = 0;


void setup() {
  size(512, 512, P3D); // start simulation with 3d mode enabled
  
  // start webcam stream 
  video = new Capture(this, 640/2, 480/2);
  video.start();



  cube=new L3D(this); // init cube
  cube.enableMulticastStreaming(2000); // start streaming current animation on port 2000
}

void draw() {
  noFill();
  background(0); // clear simulation background
  
  if (mode == 0) {
    show2D(outSideSize);
  } else {
    showCube();
  }


}

void show2D(int size) {
  PImage pOut = pixelateImage(size);
  scale(inSideSize/outSideSize);
  pOut.updatePixels();
  image(pOut, 0, 0);
}

void showCube() {
  cube.background(0); // clear cube background
  
  PImage pOut = pixelateImage(8);
  frames[7] = pOut.pixels; // save current frame pixels (7 = front of the cube)
  // loop through the 8 frames and light up pixels row by row 
  for (int j=7; j>=0; j--) {
    int i = 0;
    for (int y=7; y>=0; y--) {
      for (int x=0; x<8; x++) {
      cube.setVoxel(x, y, j, frames[j][i]);
      i++;
      }
    }
  }   
  
  // update frames displayed by pushing old frames values to the back
  // the frequency is set in global variable 'updateFrameRate'
  // 'enable3d' mode must be enabled by setting the global variable to 'true'
  if (enable3d&&nextFrame<frameCount)  {  
    for (int j=0; j<7; j++) {
      frames[j] = frames[j+1].clone();
    }
    nextFrame = frameCount+updateFrameRate;
  }
}

PImage pixelateImage(int sideSize) {
  PImage p;
  p = video.copy(); // copy current webcam frame in PImage object
  p.resize(inSideSize,inSideSize); // resize to get a square (since we want an 8x8 output)
  // Create empty image that will store the current frame pixels values
  PImage pOut = createImage(outSideSize, outSideSize, RGB);
  pOut.loadPixels(); // init pixels
  
  int pxSize = inSideSize/sideSize;
  println(pxSize);
  int loc = 0;
  
  
  for (int x=0; x<width; x+=pxSize) {
    for (int y=0; y<height; y+=pxSize) {
      float[] sum = new float[3];
      PImage subset = p.get(x, y, pxSize,pxSize);
      subset.loadPixels();

      for (int i=0; i<subset.pixels.length; i++) {
        sum[0] += red(subset.pixels[i])/subset.pixels.length;
        sum[1] += green(subset.pixels[i])/subset.pixels.length;
        sum[2] += blue(subset.pixels[i])/subset.pixels.length;
      }
      loc = (sideSize-1)-(x/pxSize) + ((y/pxSize)*sideSize);
      pOut.pixels[loc] = color(sum[0], sum[1], sum[2]);      
    }
  }
  
  return pOut;
}

// Function that reads the incoming new frames from the video stream
void captureEvent(Capture c) {
  c.read();
}


void mousePressed() {
  if (mouseButton == RIGHT) {
    mode = (mode == 1 ? 0 : 1);
  }
}