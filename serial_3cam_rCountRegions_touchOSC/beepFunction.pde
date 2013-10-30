// debugging thread, makes the screen flash when resetting,
// mostly just wanted to try using threads.

int count;

void beep() {
  count = 0;
  while (count < 30) {
    fill(0,10);
    rect(0, 0, width, height);
    count++;
  }
}

