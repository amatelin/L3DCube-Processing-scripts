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
PImage p;
PImage pOut;
Capture video; // webcam stream object

int[][] frames = new int [8][64]; // Array used to store the frames pixels values
int nextFrame = 0; 

boolean enable3d = true; // if set to false, only 1 frame is used.
int updateFrameRate = 5; // if enable3d set to true, frequency at which the past frames are updated


void setup() {
  size(480, 480, P3D); // start simulation with 3d mode enabled
  
  // start webcam stream 
  video = new Capture(this, 640/2, 480/2);
  video.start();

  // Create empty image that will store the current frame pixels values
  pOut = createImage(8, 8, RGB);
  pOut.loadPixels(); // init pixels

  cube=new L3D(this); // init cube
  cube.enableMulticastStreaming(24); // start streaming current animation on port 2000
}

void draw() {
  noFill();
  
  p = video.copy(); // copy current webcam frame in PImage object
  p.resize(480,480); // resize to get a square (since we want an 8x8 output)
  pixelateImage(60); // process frame
  
  
  background(0); // clear simulation background
  cube.background(0); // clear cube background
  
  
  frames[7] = pOut.pixels; // save current frame pixels (7 = front of the cube)
  // loop through the 8 frames and light up pixels row by row 
  for (int j=7; j>=0; j--) {
    int i = 0;
    for (int x=7; x>=0; x--) {
      for (int y=7; y>=0; y--) {
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

void pixelateImage(int pxSize) {

  // use ratio of height/width...
  float ratio;
  if (width < height) {
    ratio = height/width;
  } else {
    ratio = width/height;
  }

  // ... to set pixel height
  int pxH = int(pxSize * ratio);
  int loc = 0;
  
  noStroke();
  for (int x=0; x<width; x+=pxSize) {
    for (int y=0; y<height; y+=pxH) {
      //fill(p.get(x, y));
      //rect(x, y, pxSize, pxH);
      pOut.pixels[loc] = p.get(x,y);      
      loc+=1;
    }
  }
}

// Function that reads the incoming new frames from the video stream
void captureEvent(Capture c) {
  c.read();
}