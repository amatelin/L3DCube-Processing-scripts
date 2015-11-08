import processing.video.*;
import L3D.*;

// Instanciate cube;
L3D cube; 

Capture video; // webcam stream object

int[][] frames = new int [8][64]; // Array used to store the frames pixels values
int nextFrame = 0; 

boolean enable3d = false; // if set to false, only 1 frame is used.
int updateFrameRate = 5; // if enable3d set to true, frequency at which the past frames are updated

int inSideSize = 512; // Size of the origin image once resized. Must be a multiple of 8. 
int exp = 9; // used to recompute outSideSize on keyboard action
int outSideSize = 512; // number of pixels/side for the output image
int mode = 0; // used to switch between pixelated image and cube view


void setup() {
  size(512, 512, P3D); // start simulation with 3d mode enabled
  
  // start webcam stream 
  video = new Capture(this, 640/2, 480/2);
  video.start();

  cube=new L3D(this); // init cube
  cube.enableMulticastStreaming(2000); // start streaming current animation on port 2000
}

void draw() {
  cube.background(0); // init all voxels to black
  background(0); // clear simulation background

  // toggle between 2D and 3D view
  if (mode == 0) {
    show2D(outSideSize);
  } else {
    showCube();
  }
  
}

/* 
 * Display pixelated output image
 */
void show2D(int size) {
  PImage pOut = pixelateImage(size); // generate pixelated image
  scale(inSideSize/outSideSize); // scale image object to fill the rendering screen
  image(pOut, 0, 0); // display output image
}

/* 
 * Display cube rendering
 */
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

/*
* Reduce the number of pixels of an image by dividing it into as many equal
* areas as there are pixels on the ouput image. The average RGB value of each 
* area is computed and used to recompose the output image.
*/
PImage pixelateImage(int sideSize) {
  PImage p;
  p = video.copy(); // copy current webcam frame in PImage object
  p.resize(inSideSize,inSideSize); // resize to get a square (since we want an 8x8 output)
  // Create empty image that will store the current frame pixels values
  PImage pOut = createImage(outSideSize, outSideSize, RGB);
  pOut.loadPixels(); // init pixels
  
  int pxSize = inSideSize/sideSize;
  
  // Apply algorithm to extract average RGB value of each area of 
  // the input image and recompose the output image with the results
  for (int x=0; x<width; x+=pxSize) {
    for (int y=0; y<height; y+=pxSize) {
      float[] sum = new float[3];
      
      PImage subset = p.get(x, y, pxSize,pxSize); // get area to average
      subset.loadPixels(); // load pixels into pixels[] array

      // compute average rgb value
      for (int i=0; i<subset.pixels.length; i++) {
        sum[0] += red(subset.pixels[i])/subset.pixels.length;
        sum[1] += green(subset.pixels[i])/subset.pixels.length;
        sum[2] += blue(subset.pixels[i])/subset.pixels.length;
      }
      
      // store average in output image 
      int loc = (sideSize-1)-(x/pxSize) + ((y/pxSize)*sideSize);
      pOut.pixels[loc] = color(sum[0], sum[1], sum[2]);      
    }
  }
  
  // reload image with new pixel values and return
  pOut.updatePixels();
  return pOut;
}

// Function that reads the incoming new frames from the video stream
void captureEvent(Capture c) {
  c.read();
}

/* 
 * Toggle image or cube rendering on right click
 */
void mousePressed() {
  if (mouseButton == RIGHT) {
    mode = (mode == 1 ? 0 : 1);
  }
}

/* 
 * Increase or decrease the resolution of the output image
 * with 0 for + and 1 for -
 */
void keyPressed() {
  if (keyCode ==49) {
      exp += 1;
      outSideSize = (int)pow(2, exp);
  } else if (keyCode == 48) {
    exp -= 1;
    outSideSize = (int)pow(2, exp);
  }
}