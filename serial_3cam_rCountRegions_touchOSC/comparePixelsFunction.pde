// this comes from Shiffman - Learning Processing http://www.learningprocessing.com Example 16-13: Simple motion detection
// store a snapshot of pixels, move ahead one frame, then take another snapshot
// compare each pixel to see if the color has changed by more than the threshold
// if it has, make it colored, if it hasn't, make it white 

void comparePixels() {

  for (int x = 0; x < width; x ++ ) {
    for (int y = 0; y < height; y ++ ) {

      int loc = x + y*width;            
      color current = pixels[loc];
      color previous = background.pixels[loc];

      float r1 = red(current); 
      float g1 = green(current); 
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous); 
      float b2 = blue(previous);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      if (diff > threshold) { 
        pixels[loc] = motionColor;    // set pixel to color if motion detected
        c++;                          // increase pixel counter for each motion pixel found
        if (c > refreshTest) {        
          refresh = true;             // refresh background after finding c # of pixels
          c=0;                        // reset pixel counter
        }
      }
      else {
        pixels[loc] = color(255);     // set pixel to white if no motion detected
      }
    }
  }
}

