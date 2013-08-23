BlindSpot
=========

A Processing- and Arduino-powered installation at Beakerhead. 

Blind Spot is being created specifically for [Beakerhead](http://beakerhead.org/) and is being funded by [Sunridge Nissan](http;//www.sunridgenissan.com) in Calgary, AB.

The installation includes 96 individually-swivelling motion-detecting plastic shutters surrounding a vehicle inside of a large showcase. 

Requirements
------------

* [Adafruit 16-channel 12-bit PWM I2C Servo Driver](http://www.adafruit.com/products/815). The Adafruit library can be found [here](https://github.com/adafruit/Adafruit-PWM-Servo-Driver-Library) 
* Processing 2.0.1 
* Arduino Uno 
* Low-power micro servos such as the HXT-900 or SG92R 
* High-current, 5V power suplly (>20A for ~100 servos)
* USB Webcams


Hints
-----

I2C is meant for very short runs, yet each run in this installation isnearly 20 feet. In order to extend the distance in between each I2C slave, I used lo-cap ribbon cable wired according to pg 60 of [this specification](http://www.nxp.com/documents/user_manual/UM10204.pdf), or you could use I2C bus extenders. Because servos only need to refresh at 60Hz, instead of 100MHz or something, the relatively high capacitance of this setup doesn't seem to have any negative effect.  

For a cheap (or free), high-current, 5v power supply, use an old ATX PSU. I used [this Instructable](http://www.instructables.com/id/Converting-a-computer-ATX-power-supply-to-a-really/?ALLSTEPS) as a reference. 

I'm building the shutters out of my new favorite material: Komatex. It is expanded PVC. Super-light, easy to cut.

I'm using 6 wide-angle generic webcams. The processing sketch uses the webcam's Friendly Names. If you are using Windows 7 or later (maybe vista), you will need to change the Friendly Names in the registry to unique values ie. "Webcam #1", "Webcam#2", etc. [Here is a tutorial](http://www.eightforums.com/customization/15321-tutorial-how-change-device-names-device-manager.html) on how to do it. 

