import processing.serial.*;
import ddf.minim.*;

Serial myPort;
float lightPoints = 0;
float buttonPoints = 0;
float soundPoints = 0;
float meterWidth = 200;
PImage defaultCursor;
PImage textInputCursor;
PImage lightTexture;
PImage buttonTexture;
PImage soundTexture;
PImage progressTexture;
PImage backgroundImage;
PImage containerImage;
PImage inputFieldImage;
PImage plantImage;
PImage newPlantImage;
Minim minim;
AudioPlayer sound;
String userInput = "";

boolean cursorVisible = true;
boolean allMetersFull = false;

void setup() {
  size(420, 540);
  String portName = "COM10";  // Change to match your configuration
  myPort = new Serial(this, portName, 9600);
  
  PFont customFont = createFont("PressStart2P-Regular.ttf", 11.5);
  textFont(customFont);
  textAlign(LEFT);
  
  defaultCursor = loadImage("cursor.png");
  textInputCursor = loadImage("select.png"); // Add your text input cursor image
  lightTexture = loadImage("progress-green.png");
  buttonTexture = loadImage("progress-blue.png");
  soundTexture = loadImage("progress-red.png");
  progressTexture = loadImage("progress-bar-track.png");
  backgroundImage = loadImage("background_image.png");
  containerImage = loadImage("border-image.png");
  inputFieldImage = loadImage("input_field_image.png");
  plantImage = loadImage("plant.png");
  newPlantImage = loadImage("new_plant.png");
  // Initialize Minim and load the sound file (replace "your_sound_file.mp3" with the actual file)
  minim = new Minim(this);
  sound = minim.loadFile("sound_file.mp3");
  noCursor();
}

void draw() {
  if (myPort.available() > 0) {
    String data = myPort.readStringUntil('\n');
    if (data != null) {
      println("Received data: " + data);

      String[] values = split(data, ',');
      println("Number of values received: " + values.length);

      if (values.length >= 3) {
        int lightValue = int(values[0].trim());
        int buttonState = int(values[1].trim());
        int soundLevel = int(values[2].trim());

        if (lightValue > 200) {
          lightPoints += 10;
        }
        if (buttonState == 1) {
          buttonPoints += 10;
        }
        if (soundLevel > 50) {
          soundPoints += 10;
        }

        lightPoints = constrain(lightPoints, 0, 100);
        buttonPoints = constrain(buttonPoints, 0, 100);
        soundPoints = constrain(soundPoints, 0, 100);

        background(backgroundImage);

        // Check if the mouse is over the text input field
        if (mouseX >= 20 && mouseX <= 20 + inputFieldImage.width &&
            mouseY >= 60 && mouseY <= 60 + inputFieldImage.height) {
          cursor(textInputCursor);
        } else {
          cursor(defaultCursor);
        }

        drawDropShadowText("Your plant's name:", 20, 50);
        text(userInput, 30, 80);
        image(inputFieldImage, 20, 60);
        
        // Blinking cursor indicator
        if (frameCount % 10 == 0) {
          cursorVisible = !cursorVisible;
        }
        if (cursorVisible) {
          drawCursorIndicator(30 + textWidth(userInput), 67, 15); // Adjust the position and size as needed
        }

        displayMeter("Sunshine score:", lightPoints, 100, lightTexture, containerImage);
        displayMeter("Tap tickles   :", buttonPoints, 160, buttonTexture, containerImage);
        displayMeter("Giggle points :", soundPoints, 220, soundTexture, containerImage);

        // Check if all XP meters reached 100 points
        if (lightPoints >= 100 && buttonPoints >= 100 && soundPoints >= 100) {
          allMetersFull = true;
        }

        // Display the appropriate plant image based on the flag
        if (allMetersFull) {
          image(newPlantImage, 260, 55);
          // Play the sound
          sound.play();
          
        // Display the message box with the user input
        drawMessageBox(" ", userInput); 


        } else {
          image(plantImage, 260, 55);
        }
      } else {
        println("Invalid data format. Expected at least 3 values, got " + values.length);
        for (int i = 0; i < values.length; i++) {
          println("Value[" + i + "]: " + values[i].trim());
        }
      }
    }
  }
}

void displayMeter(String label, float points, float yPos, PImage texture, PImage containerImage) {
  image(containerImage, 25, yPos + 30, meterWidth, 30);
  fill(0);
  text(label + int(points), 20, yPos + 20);
  fill(255);
  text(label + int(points), 20 - 1, yPos + 20 - 2);
  image(progressTexture, 25, yPos + 30, meterWidth, 30);
  float barWidth = points / 100 * meterWidth;
  image(texture, 25, yPos + 30, barWidth, 30);
  noFill();
}

void drawDropShadowText(String text, float x, float y) {
  fill(0);
  text(text, x, y);
  fill(255);
  text(text, x - 1, y - 2);
}

void drawCursorIndicator(float x, float y, float height) {
  fill(0);
  rect(x, y, 2, height);
  fill(255);
  rect(x - 1, y - 1, 2, height);
}

void drawMessageBox(String message, String userName) {
  // Draw the message in the message box along with the user input
  fill(0);
  textAlign(CENTER, CENTER);
  text(message + "Congratulations! \n " + userName + " \nis now a healthy boi \njust for today at least.", 30, 360, 360, 80); // Adjust the position and size as needed
  textAlign(LEFT); // Reset text alignment to LEFT after drawing the message
  noFill();
}

void keyPressed() {
  if (key >= ' ' && key <= 'z') {
    userInput += key;
  } else if (keyCode == BACKSPACE && userInput.length() > 0) {
    userInput = userInput.substring(0, userInput.length() - 1);
  }
}

// Close Minim when the sketch is stopped
void stop() {
  sound.close();
  minim.stop();
  super.stop();
}
