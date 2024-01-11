/**
 * Sushi Battle by Claudia Neo and Kristina Greco
 */

import processing.serial.*;

final int TOTAL_WIDTH  = 32;
final int TOTAL_HEIGHT = 32;
final int NUM_CHANNELS = 3;
final int BAUD_RATE    = 921600;

Serial serial;
byte[]buffer;

//images
PImage win_img;
PImage egg_img;
PImage swordfish_img;
PImage salmon_img;

//confetti
Confetti[] flake;

int currentScene = 1;

//colors
color red = color(255,0,0);
color orange = color(204, 102, 0);
color yellow = color(255,240,0);
color green = color(0,255,0);
color blue = color(0,0,150);
color violet = color(30,30,100);
color grey = color(150,150,150);
color black = color(0);
color white = color(150);

//path
int ledLength = 32;
int pathWidth = 14;
int horizPathY = 8;
int vertPath1X = 8;
int vertPath2X = ledLength-vertPath1X;
int vertPathY = 20;
int vertPathLength = 15;

//goal(plates)
int platesDiameter = 15;
int platesDiameterSmall = 10;
int plateY = 32;
int plateX1 = vertPath1X;
int plateX2 = vertPath2X;

//sushi
int eggX = -10;
int eggY = horizPathY;
int salmonX = -30;
int salmonY = horizPathY;
int swordfishX = -50;
int swordfishY = horizPathY;

//counters
int counter1 = 0;
int counter2 = 0;

//blocking part
boolean player1Blocked = false;
boolean player2Blocked = false;

boolean downOk = false;
boolean downOkEgg = false;
boolean downOkSalmon = false;
boolean downOkSwordfish = false;


void setup() {
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
  textAlign(CENTER);
  text("Press", width/2-1, 11);  
  text("to", width/2, height/2+4);  
  text("start", width/2, height/2+13);  
}
 
void keyPressed(){
  if(key =='a' || key == 'k'){
    currentScene = 2;
    setupScene2();
  }
}

void draw() {    
  if (currentScene == 2) {
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


void setupScene2(){

}

void drawScene2(){
  background(0);
  
  //sushi path
  fill(white);
  stroke(blue);
  rectMode(CENTER);
  quad(TOTAL_WIDTH/2-pathWidth, horizPathY+pathWidth/2, TOTAL_WIDTH/2, horizPathY+pathWidth/2, 8,32, 8-pathWidth,32); //left
  quad(TOTAL_WIDTH/2+pathWidth, horizPathY+pathWidth/2, TOTAL_WIDTH/2, horizPathY+pathWidth/2, 24,32, 24+pathWidth,32); //right
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
  if((((eggX > vertPath1X-2) && (eggX < vertPath1X+2)) || ((eggX > vertPath2X-2) && (eggX < vertPath2X+2))) && keyPressed){
    if((key == 'a') || (key == 'k')){
      downOkEgg = true;
      if((eggX > vertPath1X-2) && (eggX < vertPath1X+2)){
        counter1++;
      } else if((eggX > vertPath2X-2) && (eggX < vertPath2X+2)){
        counter2++;
      }
    }
  }
  if (downOkEgg){
    if(eggY < plateY){
      eggY++;
    } else {
      //
      downOkEgg = false;
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
    if(downOkEgg){
      //translate(-eggX/2,-eggY/2);
      //rotate(PI/2.);
    }
    image(egg_img, eggX, eggY, 18, 18);
  }
  
  //.............................................................................salmon..........................................................................

  if((((salmonX > vertPath1X-2) && (salmonX < vertPath1X+2)) || ((salmonX > vertPath2X-2) && (salmonX < vertPath2X+2))) && keyPressed){ //add the "or second path" here
    if((key == 'a') || (key == 'k')){
      downOkSalmon = true;
    }
  }
  if (downOkSalmon){
    if(salmonY < plateY){
      salmonY++;
    } else {
      if((salmonX > vertPath1X-2) && (salmonX < vertPath1X+2)){
        counter1++;
      } else {
        counter2++;
      }
      downOkSalmon = false;
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
    if(downOkSalmon){
      //translate(-eggX/2,-eggY/2);
      //rotate(PI/2.);
    }
    image(salmon_img, salmonX, salmonY, 18, 18);
  }
  //.............................................................................swordfish..........................................................................
  if((((swordfishX > vertPath1X-2) && (swordfishX < vertPath1X+2)) || ((swordfishX > vertPath2X-2) && (swordfishX < vertPath2X+2))) && keyPressed && !player1Blocked && !player2Blocked){
    if((key == 'a') || (key == 'k')){
      downOkSwordfish = true;
    }
  }
  if (downOkSwordfish){
    if(swordfishY < plateY){
      swordfishY++;
    } else {
      if((swordfishX > vertPath1X-2) && (swordfishX < vertPath1X+2)){
        counter1++;
      } else {
        counter2++;
      }
      downOkSwordfish = false;
    }
  } else {
    swordfishX++;
  }
  
  if(swordfishX > 39){
    swordfishX = -22;
  }
  
  //blocking part

  //sushi display
  if(swordfishY < plateY - platesDiameter/2-2){
    stroke(black);
    imageMode(CENTER);
    if(downOkSwordfish){
      //translate(-eggX/2,-eggY/2);
      //rotate(PI/2.);
    }
    image(swordfish_img, swordfishX, swordfishY, 18, 18);
  }
  
  //blocking part
  if (keyPressed){
    if(key == 's'){ //long press
      stroke(red);
      line(TOTAL_WIDTH/2+pathWidth, horizPathY+pathWidth/2, TOTAL_WIDTH/2, horizPathY+pathWidth/2);
      player2Blocked = true;
    } else {
      player2Blocked = false;
    }
    if(key == 'l'){ //long press
      stroke(green);
      line(TOTAL_WIDTH/2-pathWidth, horizPathY+pathWidth/2, TOTAL_WIDTH/2, horizPathY+pathWidth/2);
      player1Blocked = true;
    } else {
      player1Blocked = false;
    }
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
  
  if((counter1 == 14) || (counter2 == 14)){
    currentScene = 3;
    setupScene3();
  } 
}


void setupScene3(){
  background(0);

  flake = new Confetti[100];
  for(int i=0; i<flake.length; i++){
    flake[i] = new Confetti();
    }
}

void drawScene3(){
  background(0);
  
  //confetti
  for(Confetti f : flake){
    f.fall();
    f.display();
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
  
  //winning image
  imageMode(CENTER);
  image(win_img, width/2, height/2, 20, 20);
 }