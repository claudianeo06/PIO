/**
 * This Processing sketch sends all the pixels of the canvas to the serial port.
 */

import processing.serial.*;

final int TOTAL_WIDTH  = 32;
final int TOTAL_HEIGHT = 32;
final int NUM_CHANNELS = 3;
final int BAUD_RATE    = 921600;

Serial serial;
byte[]buffer;

void setup() {
  // The Processing preprocessor only accepts literal values for size()
  // We can't do: size(TOTAL_WIDTH, TOTAL_HEIGHT);
  size(32, 32);
  

  buffer = new byte[TOTAL_WIDTH * TOTAL_HEIGHT * NUM_CHANNELS];

  String[] list = Serial.list();
  printArray(list);
  
  try {
    // On macOS / Linux see the console for all wavailable ports
    //final String PORT_NAME = "/dev/cu.usbserial-02B60E77";
    // On Windows the ports are numbered
    final String PORT_NAME = "COM4";
    serial = new Serial(this, PORT_NAME, BAUD_RATE);
  } catch (Exception e) {
    println("Serial port not intialized...");
  }  
  background(0);
}
 
 
void keyPressed(){
  if(key =='1'){
    scene1();
  } else if(key =='2'){
    scene2();
  } else if(key == '3'){
    scene3();
  }else if(key == '4'){
    scene4();
  }
}

void draw() {    
  // --------------------------------------------------------------------------
  // Write to the serial port (if open)
  if (serial != null) {
    loadPixels();
    int idx = 0;
    for (int i=0; i<pixels.length; i++) {
      color c = pixels[i];
      buffer[idx++] = (byte)(c >> 16 & 0xFF); // r
      buffer[idx++] = (byte)(c >> 8 & 0xFF);  // g
      buffer[idx++] = (byte)(c & 0xFF);       // b
    }
    serial.write('*');     // The 'data' command
    serial.write(buffer);  // ...and the pixel values
  }
}


void scene1(){
  background(0);
  fill(255);
  text("Press", 2, 10);  
  text("to", width/3, 18);  
  text("start", 4, 26);  
}
void scene2(){
  background(0);
  fill(random(255), random(255), random(255));
  text("2", width/3, 18);  
  ellipse(random(width), random(height), 10, 10);  
}
void scene3(){
  background(0);
  fill(random(255), random(255), random(255));
  text("3", width/3, 18);  
  ellipse(random(width), random(height), 10, 10);  
}
void scene4(){
  background(0);
  fill(random(255), random(255), random(255));
  text("4", width/3, 18);  
  ellipse(random(width), random(height), 10, 10);  
}
