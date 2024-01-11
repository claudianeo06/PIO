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

PImage SBlogo_img;
PImage win_img;
PImage egg_img;
PImage swordfish_img;
PImage salmon_img;

Confetti[] snow;

int currentScene = 1;

//colors
color orange = color(204, 102, 0);
color black = color(0);
color white = color(150);
color grey = color(150,150,150);
color blue = color(0,0,150);
color red = color(255,0,0);
color violet = color(30,30,100);
color green = color(0,255,0);
color yellow = color(255,240,0);

int ledLength = 32;
int pathWidth = 14;
int horizPathY = 8;
int vertPath1X = 8;
int vertPath2X = ledLength-vertPath1X;
int vertPathY = 20;
int vertPathLength = 15;

int platesDiameter = 15;
int platesDiameterSmall = 10;
int plateY = 32;
int plateX1 = vertPath1X;
int plateX2 = vertPath2X;

int eggX = -10;
int eggY = horizPathY;
int eggWidth = 4;//to we use it?
int eggHeight = 8;

int salmonX = -30;
int salmonY = horizPathY;

int swordfishX = -50;
int swordfishY = horizPathY;

//counters
int counter1 = 0;
int counter2 = 0;

boolean downOk = false;


void setup() {
  // The Processing preprocessor only accepts literal values for size()
  // We can't do: size(TOTAL_WIDTH, TOTAL_HEIGHT);
  size(32, 32);
  
  SBlogo_img = loadImage("SBlogo.png");
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
    final String PORT_NAME = "COM4";
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
  //imageMode(CENTER);
  //image(SBlogo_img, width/2, height/2, 32, 32);
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
  fill(white);
  stroke(blue);
  rectMode(CENTER);
  quad(TOTAL_WIDTH/2-pathWidth+3, horizPathY+3, TOTAL_WIDTH/2+3, horizPathY+3, 8,32, 8-pathWidth,32); //left
  quad(TOTAL_WIDTH/2+pathWidth-3, horizPathY+3, TOTAL_WIDTH/2-3, horizPathY+3, 24,32, 24+pathWidth,32); //right
  rect(ledLength/2-1,horizPathY,ledLength+2, pathWidth);
  //rect(vertPath1X, vertPathY, pathWidth, vertPathLength);
  //rect(vertPath2X, vertPathY, pathWidth, vertPathLength);
  
  //plates
  //stroke(black);
  //fill(white);
  //ellipse(plateX1,plateY,platesDiameter,platesDiameter);
  //ellipse(plateX2,plateY,platesDiameter,platesDiameter);
  
  //.............................................................................egg..........................................................................
  //this block has to be used for each sushi (use a for loop?)
  //
  if((((eggX > vertPath1X-2) && (eggX < vertPath1X+2)) || ((eggX > vertPath2X-2) && (eggX < vertPath2X+2))) && keyPressed){ //add the "or second path" here
    downOk = true;
  }
  if (downOk){
    if(eggY < plateY){
      eggY++;
    } else {
      if((eggX > vertPath1X-2) && (eggX < vertPath1X+2)){
        counter1++;
      } else {
        counter2++;
      }
      downOk = false;
    }
  } else {
    eggX++;
  }
  
  if(eggX > 39){
    eggX = -22;
  }
  //sushi display
  if(eggY < plateY - platesDiameter/2-2){
    stroke(black);
    imageMode(CENTER);
    if(downOk){
      //translate(-eggX/2,-eggY/2);
      //rotate(PI/2.);
    }
    image(egg_img, eggX, eggY, 18, 18);
  }
  
  //.............................................................................salmon..........................................................................

  if((((salmonX > vertPath1X-2) && (salmonX < vertPath1X+2)) || ((salmonX > vertPath2X-2) && (salmonX < vertPath2X+2))) && keyPressed){ //add the "or second path" here
    downOk = true;
  }
  if (downOk){
    if(salmonY < plateY){
      salmonY++;
    } else {
      if((salmonX > vertPath1X-2) && (salmonX < vertPath1X+2)){
        counter1++;
      } else {
        counter2++;
      }
      downOk = false;
    }
  } else {
    salmonX++;
  }
  
  if(salmonX > 39){
    salmonX = -22;
  }
  
  //sushi display
  if(salmonY < plateY - platesDiameter/2-2){
    stroke(black);
    imageMode(CENTER);
    if(downOk){
      //translate(-eggX/2,-eggY/2);
      //rotate(PI/2.);
    }
    image(salmon_img, salmonX, salmonY, 18, 18);
  }
  //.............................................................................swordfish..........................................................................
  if((((swordfishX > vertPath1X-2) && (swordfishX < vertPath1X+2)) || ((swordfishX > vertPath2X-2) && (swordfishX < vertPath2X+2))) && keyPressed){ //add the "or second path" here
    downOk = true;
  }
  if (downOk){
    if(swordfishY < plateY){
      swordfishY++;
    } else {
      if((swordfishX > vertPath1X-2) && (swordfishX < vertPath1X+2)){
        counter1++;
      } else {
        counter2++;
      }
      downOk = false;
    }
  } else {
    swordfishX++;
  }
  
  if(swordfishX > 39){
    swordfishX = -22;
  }

  //sushi display
  if(swordfishY < plateY - platesDiameter/2-2){
    stroke(black);
    imageMode(CENTER);
    if(downOk){
      //translate(-eggX/2,-eggY/2);
      //rotate(PI/2.);
    }
    image(swordfish_img, swordfishX, swordfishY, 18, 18);
  }
  
  
  //points system
  fill(yellow);
  stroke(yellow);
  line(15,0,16,0);
  fill(red);
  stroke(red);
  line(0,0,counter1,0);
  fill(green);
  stroke(green);
  line(31,0,31-counter2,0);
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
