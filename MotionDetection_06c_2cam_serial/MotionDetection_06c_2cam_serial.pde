//

import processing.video.*;
import processing.serial.*;

Capture cam1;         // define cameras
Capture cam2;
Serial myPort;      // define serial
PImage background;    // define image to hold background data

Region[] reg;                 // array for the motion detection regions
float rCount = 32;             // # of regions (must equal # of shutters/servos)
float threshold = 80;   // motion threshold
int error = 25;          // # of pixels to ignore before detect - improves margin of error!

boolean refresh = false;      // detect if there are too many colored pixels
int refreshTest = 130000;    // 1300000 - 2cam, how many blue pixels to detect before refresh
//int resetTime = 5000;         // how often to refresh the background automatically

int camW = 176;          // cam width -  | 176 | 352 | 320 | 160 |
int camH = 144;          // cam height - | 144 | 288 | 240 | 120 |
int camFR = 30;          // cam Frame Rate
int numCam = 2;          // number of cameras
int fR = 15;             // sketch frame rate

float rWidth;                   // define motion detect region width
color motionColor = color(0, 100, 150);
int c = 0;                    // initialize refresh counter

int timer;                    // define reset reference timer







void setup() {
  size((camW*numCam), camH);
  frameRate(fR);

  rWidth = width/rCount;                  // automatically set motion detect region width
  println(width);
  println(rWidth);
  reg = new Region[int(rCount)];               // build motion detect region array
  for (int i = 0; i < rCount; i++) {
    reg[i] = new Region(rWidth*(i+1), rWidth, i+1);   // position, width, serial servo-trigger byte
  }
  
  // initialize serial 
  String[] serial = Serial.list();
  if (serial.length == 0) {
    println("Hook up your Arduino, dummy!");
    exit();
  }
  else {
    println(Serial.list());
    myPort = new Serial(this, Serial.list()[0], 115200);
  }

  /*---------  Find the cameras and turn them on!  ---------*/
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("No cameras available, dummy!");
    exit();
  } 
  else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam1 = new Capture(this, camW, camH, "WideCam 320 #1", camFR);  // these names must be defined in the registry
    cam2 = new Capture(this, camW, camH, "WideCam 320 #2", camFR);

    background = createImage(width, height, RGB);                   // create background image for comparison later
    cam1.start();      // turn the cameras on
    cam2.start();

  }
}



void draw() {
  if (cam1.available()) {
    //if (keyPressed == true || millis() - timer >= resetTime) {  // manual or timer based auto-refresh
    if (keyPressed == true || refresh == true) {                  // manual or pixel count based auto-refresh (may also use refresh variable for external manual-refresh ie. a button)

      background.set((camW*0), 0, cam1);      // add all camera content to background pixel holder (upon refresh)
      background.set((camW*1), 0 , cam2);


      timer = millis();  // reset the timer countdown
      //thread("beep");    // debug. comment out for real-world
      refresh = false;
    }
    cam1.read();      // load current cameras into memory
    cam2.read();

  }
  set((camW*0), 0, cam1);      // add a-ll camera content to current pixel array
  set((camW*1), 0, cam2);


  loadPixels();              // load the current pixel array
  background.loadPixels();   // load the stored pixel array
  comparePixels();           // compare and display results
  updatePixels();            // update the pixel array with single color results for region detection
  
  if (frameRate > 10) {                 // only update if the sketch is surviving!
    for (int i = 0; i < rCount; i++) {
      reg[i].update();                  // detect motion in each region independantly 
    }
  }
  
  frame.setTitle(int(frameRate) + " fps");
}



