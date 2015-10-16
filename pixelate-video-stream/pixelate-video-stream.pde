import processing.video.*;
import L3D.*;

L3D cube;


PImage p;
PImage model;
Capture video;
int frame;

void setup() {
  size(480, 480, P3D);           // set size to that of the image
  video = new Capture(this, 640/2, 480/2);
  video.start();

  model = createImage(8, 8, RGB);
  println(model.height);
  println(model.width);
  model.loadPixels();

  colorMode(HSB, 255);               // allows us to access the brightness of a color

  cube=new L3D(this);
  cube.enableMulticastStreaming(2000);
  frame=8;
  
}

void draw() {
  noFill();
  p = video.copy();
  p.resize(480,480);
  pixelateImage(60);
  
  background(0);
  cube.background(0);
  int i = 0;
  for (int x=0; x<8; x++) {
    for (int y=0; y<8; y++) {
      cube.setVoxel(x, y, frame, model.pixels[i]);
      i++;
    }
  }
  /*if ((frameCount%20)>10)  {  //turn the LED on for ten frames, then off for ten frames
    frame++;
  }
  if (frame==8) {
    frame=0;
  }*/
  //noLoop();
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
      fill(p.get(x, y));
      model.pixels[loc] = p.get(x,y);
      
      rect(x, y, pxSize, pxH);
      loc+=1;

    }
  }
}

/*void mousePressed() {
  loop();
}*/

void captureEvent(Capture c) {
  c.read();
}