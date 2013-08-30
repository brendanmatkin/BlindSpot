/* Special instructions: 

Using an arduino UNO r3, connect SDA and SCL to SDA and SCL on the arduino (labels on back). 
Connect GND to GND and VCC to 5v. 
See https://github.com/brendanmatkin/BlindSpot for other tips and instructions.  

This test/example/whatever is based off of the example from the adafruit PWM Servo Driver Library*/

#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>
/* This library can be found at https://github.com/adafruit/Adafruit-PWM-Servo-Driver-Library
and is for this controller: ------> http://www.adafruit.com/products/815
Adafruit invests time and resources providing this open source code, please support Adafruit and open-source hardware by purchasing products from Adafruit! */

Adafruit_PWMServoDriver pwm1 = Adafruit_PWMServoDriver(0x40);    // initialize the servo drivers
Adafruit_PWMServoDriver pwm2 = Adafruit_PWMServoDriver(0x41);    // binary address starts at 0x40
Adafruit_PWMServoDriver pwm3 = Adafruit_PWMServoDriver(0x42);
Adafruit_PWMServoDriver pwm4 = Adafruit_PWMServoDriver(0x43);
Adafruit_PWMServoDriver pwm5 = Adafruit_PWMServoDriver(0x44);
Adafruit_PWMServoDriver pwm6 = Adafruit_PWMServoDriver(0x45);


#define SERVOMIN  150     // (out of 4096) pulse length
#define SERVOMAX  610     // (out of 4096) pulse length

int servonum = 0;         // servo counter
int degrees = 0;          // initialize. 180 and 75 are closest to 180 and 90 for these servos
boolean ud = true;        // up/down boolean (servo position alternator)
int waveSpeed = 100;      // speed of the servo wave. Lower is faster (keep it above 1). >~200 is one servo at a time without overlap

void setup() {
  
  pwm1.begin();           // start wire communication with servo controllers
  pwm2.begin();
  pwm3.begin();
  pwm4.begin();
  pwm5.begin();
  pwm6.begin();
  
  pwm1.setPWMFreq(60);    // leave at 60 (update frequency for servos)
  pwm2.setPWMFreq(60);
  pwm3.setPWMFreq(60);
  pwm4.setPWMFreq(60); 
  pwm5.setPWMFreq(60);
  pwm6.setPWMFreq(60); 
  
}


void loop() {
  if (ud == true) {       // up/down boolean (servo position alternator)
    degrees = 180;        // anything between 0 and 180
  } else {
    degrees = 75;         // anything between 0 and 180
  }
  
  int pulselength = map(degrees,0,180,SERVOMIN,SERVOMAX);    // re-map degrees to pulselength for the servos (so we can think in degrees)
  //pwm.setPWM(5,0,pulselength);
  
  if (servonum <= 15) {                                      // divide the servo number out among the controllers
    pwm1.setPWM(servonum, 0, pulselength);                   // (each servo on each controller is numbered 0-15)
  }
  else if (servonum <= 31) {
    pwm2.setPWM(servonum-16, 0, pulselength);
  }
  else if (servonum <= 47) {
    pwm3.setPWM(servonum-32, 0, pulselength);
  }
  else if (servonum <= 63) {
    pwm4.setPWM(servonum-48, 0, pulselength);
  }
  else if (servonum <= 79) {
    pwm5.setPWM(servonum-64, 0, pulselength);
  }
  else {
    pwm6.setPWM(servonum-80, 0, pulselength);
  }
  
  delay(waveSpeed);       // delay before setting the position of the next servo... 
  servonum ++;            // this stuff basically makes the whole sketch into a for loop... 
  if (servonum > 95) {
    servonum = 0;
    ud = !ud;             // change direction..
  }
}
