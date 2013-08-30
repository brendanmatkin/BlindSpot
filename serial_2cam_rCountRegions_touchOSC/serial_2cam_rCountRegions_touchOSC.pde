// touchOSC CONTROLS (all in page one of "simple"):
// fader 1 = motion threshold (0-300)
// fader 2 = margin of error regional pixel-count threshold (0-200)
// fader 3 = auto-refresh global pixel-count threshold (0-2,500,000)
// toggle 1 = manual refresh

import processing.video.*;
import processing.serial.*;

import oscP5.*;          // talk to TouchOSC
import netP5.*;
OscP5 oscP5;
float v_fader1 = 0.0f;   // touchOSC screen1, fader1
float v_fader2 = 0.0f;   // touchOSC screen1, fader2
float v_fader3 = 0.0f;   // touchOSC screen1, fader3
float v_toggle1 = 0.0f;  // touchOSC screen1, toggle1

Capture cam1;         // define cameras
Capture cam2;
Serial myPort;        // define serial
PImage background;    // define image to hold background data

Region[] reg;              // array for the motion detection regions
float rCount = 96;         // # of regions (must equal # of shutters/servos)
float threshold = 100;     // motion threshold
int error = 50;            // # of pixels to ignore before detect - improves margin of error!

boolean refresh = false;      // detect if there are too many colored pixels
int refreshTest = 700000;     // 1300000 - 2cam,60fps. how many blue pixels to detect before refresh
//int resetTime = 5000;       // how often to refresh the background automatically

int camW = 352;          // cam width -  | 176 | 352 | 320 | 160 |
int camH = 288;          // cam height - | 144 | 288 | 240 | 120 |
int camFR = 30;          // cam Frame Rate
int numCam = 2;          // number of cameras
int fR = 15;             // sketch frame rate

float rWidth;                           // define motion detect region width
int c = 0;                              // initialize refresh counter
color motionColor = color(0, 100, 150); // set the detection color (arbitrary, just not white)
int timer;                              // define reset reference timer


/******************************************************************************/


void setup() {
  size((camW*numCam), camH);
  frameRate(fR);
  
  oscP5 = new OscP5(this,8000);           // new OSC host listening on port 8000

  rWidth = width/rCount;                  // automatically set motion detect region width
  println(width);
  println(rWidth);
  reg = new Region[int(rCount)];                      // build motion detect region array
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

  // find the cameras and turn them on!
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



/*************************************************************************************/



void oscEvent(OscMessage theOscMessage) {                    // listen for OSC messages
    String addr = theOscMessage.addrPattern();
    float  val  = theOscMessage.get(0).floatValue();
    
    if(addr.equals("/1/fader1"))        { v_fader1 = val; }
    else if(addr.equals("/1/fader2"))   { v_fader2 = val; }
    else if(addr.equals("/1/fader3"))   { v_fader3 = val; }
    else if(addr.equals("/1/toggle1"))  { v_toggle1 = val; }
}



/***************************************************************************************/



void draw() {
  if (v_fader1 >0.0) {              // touchOSC fader 1 = motion threshold
    threshold = v_fader1*300;
  }
  if (v_fader2 > 0.0) {             // touchOSC fader 2 = margin of error
    error = int(v_fader2*200);
  }
  if (v_fader3 > 0.0) {             // touchOSC fader 3 = refresh counter
    refreshTest = int(v_fader3*2500000);
  }

  if (cam1.available()) {
    //if (keyPressed == true || millis() - timer >= resetTime) {        // manual or timer based auto-refresh
    if (keyPressed == true || v_toggle1 == 1.0f || refresh == true) {   // manual or pixel count based auto-refresh (may also use refresh variable for external manual-refresh ie. a button)

      background.set((camW*0), 0, cam1);      // add all camera content to background pixel holder (upon refresh)
      background.set((camW*1), 0 , cam2);


      timer = millis();  // reset the timer countdown
      //thread("beep");    // debug. comment out for real-world
      refresh = false;
    }
    cam1.read();         // load current cameras into memory
    cam2.read();

  }
  set((camW*0), 0, cam1);    // add a-ll camera content to current pixel array
  set((camW*1), 0, cam2);
  
  loadPixels();              // load the current pixel array
  background.loadPixels();   // load the stored pixel array
  comparePixels();           // compare and display results
  updatePixels();            // update the pixel array with single color results for region detection
  
  if (frameRate > 3) {                 // only update if the sketch is surviving!
    for (int i = 0; i < rCount; i++) {
      reg[i].update();                 // detect motion in each region independantly 
    }
  }
  
  // show OSC-variable numbers 
  fill(0,200);
  textSize(12);
  text(int(threshold),10,22);
  text(error,10,37);
  text(refreshTest,10,52);
 
  frame.setTitle(int(frameRate) + " fps");
}



