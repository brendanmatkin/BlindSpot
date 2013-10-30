boolean found = false;


class Region {
  float xMax, checkWidth, xMin;
  int trigger;
  Region (float _xMax, float _rWidth, int _trigger) {
    xMax = _xMax;
    checkWidth = _rWidth;
    xMin = _xMax - _rWidth;
    trigger = _trigger;
  }
  void update() {
    //myPort.write(trigger+1);  // uncomment for serial servo trigger
    fill(0, 150, 50, 100);            // reset indicator color to green
    found = false;              // reset pixel found
    int c = 0;                  // local pixel counter variable
    for (float x = xMin; x < xMax; x ++) { 
      for (float y = 0; y < height; y ++) {
        int loc = int(x) + int(y)*width;
        if (pixels[loc] == motionColor) {
          c++;                // add to pixel counter
          if (c > error) {    // only throws if # of detected pixels is greater than error (ignore) variable
            fill(150, 40, 20, 100);  // set indicator-color to red
            found = true;     // for sending serial servo data
            continue;         // kick us out of the for loop
          }
        }
      }
    }
    if (found == true) {           // uncomment for serial servo trigger
      myPort.write(trigger);         // send byte(s) to set servo at 90*
    } else {    
      myPort.write(trigger+int(rCount));  // this sets servo back to 0*
    }
    stroke(0, 50);                     // these display the regions and trigger indicators
    line(xMin, 0, xMin, height);
    noStroke();
    rect(xMin, 0, checkWidth, 10);
  }
}

