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

PImage win_img;
PImage egg_img;
PImage swordfish_img;
PImage salmon_img;

Confetti[] snow;

int currentScene = 1;

//colors
color orange = color(204, 102, 0);
color black = color(0);
color white = color(255);
color grey = color(150,150,150);
color blue = color(0,0,150);
color red = color(255,0,0);
color violet = color(30,30,100);
color green = color(0,255,0);

int ledLength = 32;
int pathWidth = 10;
int horizPathY = 7;
int vertPath1X = 8;
int vertPath2X = ledLength-vertPath1X;
int vertPathY = 20;
int vertPathLength = 15;

int platesDiameter = 15;
int platesDiameterSmall = 10;
int plateY = 32;
int plateX1 = vertPath1X;
int plateX2 = vertPath2X;

int makiX = 0;
int makiY = horizPathY;
int makiWidth = 4;
int makiHeight = 8;

//counters
int counter1 = 0;
int counter2 = 0;

boolean downOk = false;


void setup() {
  // The Processing preprocessor only accepts literal values for size()
  // We can't do: size(TOTAL_WIDTH, TOTAL_HEIGHT);
  size(32, 32);
  
  win_img = loadImage("win.png");  
  egg_img = loadImage("egg.png");  
  salmon_img = loadImage("salmon.png");  
  swordfish_img = loadImage("swordfish.png");  

  buffer = new byte[TOTAL_WIDTH * TOTAL_HEIGHT * NUM_CHANNELS];
  
  

  String[] list = Serial.list();
  printArray(list);
  
  try {
    // On macOS / Linux see the console for all wavailable ports
    //final String PORT_NAME = "/dev/cu.usbserial-02B60E77";
    // On Windows the ports are numbered
    final String PORT_NAME = "COM5";
    serial = new Serial(this, PORT_NAME, BAUD_RATE);
  } catch (Exception e) {
    println("Serial port not intialized...");
  }  
  background(0);
}
 
 
void keyPressed(){
  if(key =='1'){
    currentScene = 1;
    setupScene1();
  } else if(key =='2'){
    currentScene = 2;
    setupScene2();
  } else if(key == '3'){
    currentScene = 3;
    setupScene3();
  }
}

void draw() {    
    if (currentScene == 1) {
    drawScene1();
  } else if (currentScene == 2) {
    drawScene2();
  } else if (currentScene == 3) {
    drawScene3();
  }
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


void setupScene1(){
  background(0);
  fill(255);
  textAlign(CENTER);
  text("Press", width/2-1, 11);  
  text("to", width/2, height/2+4);  
  text("start", width/2, height/2+13);  
}

void drawScene1(){
}



void setupScene2(){
  
  

}

void drawScene2(){
  background(0);
  //sushi path
  fill(violet);
  stroke(blue);
  rectMode(CENTER);
  rect(ledLength/2-1,horizPathY,ledLength+2, pathWidth);
  rect(vertPath1X, vertPathY, pathWidth, vertPathLength);
  rect(vertPath2X, vertPathY, pathWidth, vertPathLength);
  
  //plates
  stroke(black);
  fill(white);
  ellipse(plateX1,plateY,platesDiameter,platesDiameter);
  ellipse(plateX2,plateY,platesDiameter,platesDiameter);
  //plates shadow
  //stroke(black);
  //noFill();
  //ellipse(plateX1,plateY,platesDiameterSmall,platesDiameterSmall);
  //ellipse(plateX2,plateY,platesDiameterSmall,platesDiameterSmall);
  
  //counters
 
  //textMode(CENTER);
  //textAlign(CENTER);
  //textSize(10);
  //text(counter1, plateX1, plateY+4);
  //text(counter2, plateX2, plateY+4);
  
  

  
  
  //this block has to be used for each sushi (use a for loop?)
  //
  if((makiX > vertPath1X-2) && (makiX < vertPath1X+2) && keyPressed){ //add the "or second path" here
    downOk = true;
  }
  if (downOk){
    if(makiY < plateY){
      makiY++;
    } else {
      counter1++;
      downOk = false;
    }
  } else {
    makiX++;
  }
  
  
  fill(red);
  stroke(red);
  line(15,31,15-counter1,31);
  fill(green);
  stroke(green);
  line(16,31,16+counter2,31);
  
  
  //maki display
  if(makiY < plateY - platesDiameter/2-2){
    stroke(black);
    imageMode(CENTER);
    if(downOk){
      //translate(-makiX/2,-makiY/2);
      //rotate(PI/2.);
    }
    image(egg_img, makiX, makiY, 18, 18);
    //stroke(orange);
    //fill(orange);
    //rectMode(CENTER);
    //rect(makiX,makiY, 7, 7);
  }
}

void setupScene3(){
  background(0);

  snow = new Confetti[100];
  for(int i=0; i<snow.length; i++){
    snow[i] = new Confetti();
    }
}

void drawScene3(){
  background(0);
  for(Confetti s : snow){
    s.fall();
    s.display();
    }
  imageMode(CENTER);
  image(win_img, width/2, height/2, 20, 20);
 }
