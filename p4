#include <Prizm.h>

Prizm prizm;

const int ultrasonicPin = 2; // Ultrasonic sensor pin
const int leftMotorPin = 1; // Left motor pin
const int rightMotorPin = 0; // Right motor pin
const int lineSensorPin = A0; // Line sensor pin

const int safeDistance = 15; // Safe distance in cm
const int maxDistance = 50; // Maximum distance to start rotating in cm

void setup() {
  prizm.begin();
  pinMode(ultrasonicPin, INPUT);
  pinMode(lineSensorPin, INPUT);
}

void loop() {
  int distance = prizm.readUltrasonic(ultrasonicPin);
  int lineSensorValue = prizm.readLineSensor(lineSensorPin);

  // If a black line is detected, stop the robot
  if (lineSensorValue < 1000) {
    prizm.setMotorSpeed(leftMotorPin, 0);
    prizm.setMotorSpeed(rightMotorPin, 0);
    return;
  }

  if (distance > maxDistance) {
    // Rotate until the nearest target is found
    prizm.setMotorSpeed(leftMotorPin, 50);
    prizm.setMotorSpeed(rightMotorPin, -50);
  } else if (distance > safeDistance) {
    // Move closer to the target
    prizm.setMotorSpeed(leftMotorPin, 100);
    prizm.setMotorSpeed(rightMotorPin, 100);
  } else if (distance < safeDistance) {
    // Move backwards to maintain safe distance
    prizm.setMotorSpeed(leftMotorPin, -100);
    prizm.setMotorSpeed(rightMotorPin, -100);
  }
}
