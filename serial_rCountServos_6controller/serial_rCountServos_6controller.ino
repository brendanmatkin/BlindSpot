/* Special instructions: 

Using an arduino UNO r3, connect SDA and SCL to SDA and SCL on the arduino (labels on back). 
Connect GND to GND and VCC to 5v. 
See https://github.com/brendanmatkin/BlindSpot for other tips and instructions. 

Requires a corresponding Processing sketch also found at the above github link. */


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


#define SERVOMIN  150        // (out of 4096) pulse length
#define SERVOMAX  610        // (out of 4096) pulse length

int servonum = 0;            // servonum counter
int degrees = 0;             // 180 and 75 are closest to 180 and 90 for these servos
const int servoOpen = 180;   // degrees on servo
const int servoClosed = 75;  // degrees on servo

int incomingByte = 0;        // variable to store serial read
const int rCount = 96;       // match this to rCount in corresponding processing sketch




void setup() {
  
  pwm1.begin();            // start wire communication with servo controllers
  pwm2.begin();
  pwm3.begin();
  pwm4.begin();
  pwm5.begin();
  pwm6.begin();
  
  pwm1.setPWMFreq(60);     // leave at 60 (update frequency for servos)
  pwm2.setPWMFreq(60);
  pwm3.setPWMFreq(60);
  pwm4.setPWMFreq(60);     
  pwm5.setPWMFreq(60);
  pwm6.setPWMFreq(60);
  
  Serial.begin(9600);   // this to talk with processing
}


void loop() {
  
  if (Serial.available() >0) {
    incomingByte = Serial.read();          // set byte sent from Processing to incomingByte (starts at 1)
    if (incomingByte <= rCount) {          // Processing sends a byte equal to the region number or the region number plus the rCount
      servonum = incomingByte;             // this little if/else is just to make sure it gets to the correct servo.
    } 
    else {                                 
      servonum = incomingByte - rCount;
    }
  }

  if (incomingByte <= rCount) {      // byte equal to the region is motion detected
    degrees = servoClosed;
  } 
  else {                             // byte equal to the region plus the rCount is no motion
    degrees = servoOpen;
  }
  
  int pulselength = map(degrees,0,180,SERVOMIN,SERVOMAX);  // re-map degrees to pulselength for the servos (so we can think in degrees)
  
  if (servonum <= 16) {                                    // divide the servo number out among the controllers
    pwm1.setPWM(servonum-1, 0, pulselength);               // (each servo on each controller is numbered 0-15)
  }
  else if (servonum <= 32) {
    pwm2.setPWM(servonum-17, 0, pulselength);
  }
  else if (servonum <= 48) {
    pwm3.setPWM(servonum-33, 0, pulselength);
  }
  else if (servonum <= 64) {
    pwm4.setPWM(servonum-49, 0, pulselength);
  }
  else if (servonum <= 80) {
    pwm5.setPWM(servonum-65, 0, pulselength);
  }
  else {
    pwm6.setPWM(servonum-81, 0, pulselength);
  }
}

