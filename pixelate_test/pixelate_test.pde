import processing.video.*;

PImage p;
Capture video;

void setup() {
  size(480, 480);           // set size to that of the image
  video = new Capture(this, 640/2, 480/2);
  video.start();

  colorMode(HSB, 255);               // allows us to access the brightness of a color

}

void draw() {
  scale(2);
  p = video.copy();
  pixelateImage(30);
  noFill();
}

void pixelateImage(int pxSize) {
 
  // use ratio of height/width...
  float ratio;
  if (width < height) {
    ratio = height/width;
  }
  else {
    ratio = width/height;
  }
  
  // ... to set pixel height
  int pxH = int(pxSize * ratio);
  
  noStroke();
  for (int x=0; x<width; x+=pxSize) {
    for (int y=0; y<height; y+=pxH) {
      fill(p.get(x, y));
      rect(x, y, pxSize, pxH);
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}