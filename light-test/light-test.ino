#include <Adafruit_CircuitPlayground.h>

void setup() {
  Serial.begin(9600); // Initialize serial communication at 9600 baud
  CircuitPlayground.begin(); // Initialize Circuit Playground library

  // Wait for serial connection to be established
  while (!Serial) {
    delay(10);
  }
  
  Serial.println("Setup complete");
}

void loop() {
  // Read light sensor
  int lightValue = CircuitPlayground.lightSensor();

  // Read button state
  bool buttonPressed = CircuitPlayground.leftButton();

  // Read sound level from the microphone
  int soundLevel = CircuitPlayground.soundSensor();

  // Read accelerometer data
  float accelX = CircuitPlayground.motionX();
  float accelY = CircuitPlayground.motionY();
  float accelZ = CircuitPlayground.motionZ();

  // Debug print to check values
  Serial.print("Light Value: ");
  Serial.print(lightValue);
  Serial.print(", Button State: ");
  Serial.println(buttonPressed ? "Pressed" : "Released");
  Serial.print("Sound Level: ");
  Serial.println(soundLevel);
  Serial.print(", Accelerometer (X, Y, Z): ");
  Serial.print(accelX);
  Serial.print(", ");
  Serial.print(accelY);
  Serial.print(", ");
  Serial.println(accelZ);

  // Send data to Processing sketch
  Serial.print(lightValue);
  Serial.print(",");
  Serial.print(buttonPressed ? 1 : 0);
  Serial.print(",");
  Serial.print(soundLevel);
  Serial.print(",");
  Serial.print(accelX);
  Serial.print(",");
  Serial.print(accelY);
  Serial.print(",");
  Serial.println(accelZ);

  delay(100); // Optional delay to avoid spamming the serial connection
}
