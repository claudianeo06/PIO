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
PImage background_img;
PImage win_img;
PImage egg_img;
PImage maki_img;
PImage rice_img;

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
int riceX = -30;
int riceY = horizPathY;
int makiX = -50;
int makiY = horizPathY;

//counters
int counter1 = 0;
int counter2 = 0;

//blocking part
boolean player1Blocked = false;
boolean player2Blocked = false;

boolean downOk = false;
boolean downOkEgg = false;
boolean downOkrice = false;
boolean downOkmaki = false;

int sushiX = 10;
int sushiY = horizPathY;
boolean leftPathDown = false;
boolean rightPathDown = false;

boolean rightPathDownEgg = false;
boolean leftPathDownEgg = false;
boolean rightPathDownrice = false;
boolean leftPathDownRice = false;
boolean rightPathDownMaki = false;
boolean leftPathDownMaki = false;

int tab []= new int [2];
int tab2 []= new int [2];
  
int sushiType; //1,2,3

//game running
boolean isGameRunning = true;
  
void setup() {
  size(32, 32);
  
  background_img = loadImage("background.png");
  win_img = loadImage("win.png");  
  egg_img = loadImage("egg.png");  
  rice_img = loadImage("rice.png");  
  maki_img = loadImage("maki.png");  
 
  isGameRunning = true;

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

void keyReleased(){
    if(key == 's'){
      player2Blocked = false;
    }else if(key == 'l'){
      player1Blocked = false;
    }
}

void draw() {    
  if (currentScene ==1){
    setup();  
  }else if (currentScene == 2) {
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
  imageMode(CENTER);
  image(background_img, width/2,height/2);
  
  
  //.............................................................................egg..........................................................................
  
  
  //.............................................................................rice..........................................................................

  
  //.............................................................................maki..........................................................................
  

  sushiType = 1;
  tab2 = sushiMove(sushiType, eggX, eggY, egg_img);
  eggX = tab2[0];
  eggY = tab2[1];
  sushiType = 2;
  tab2 = sushiMove(sushiType, riceX, riceY, rice_img);
  riceX = tab2[0];
  riceY = tab2[1];
  sushiType = 3;
  sushiMove(sushiType, makiX, makiY, maki_img);
  makiX = tab2[0];
  makiY = tab2[1];
  
  barrierDisplay();
  
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
  
  isGameRunning = false;
  
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
  
  if(key == ' '){
    currentScene = 1;
  }
}
 
 
int[] sushiMove(int sushiType, int sushiX, int sushiY, PImage sushi_img){
  

  //tab[0] = 5;
  //tab[1] = 6;
  
  
  if(keyPressed){
    if(key == 'a'){

      if(!player1Blocked){
        if((sushiX > vertPath1X-2) && (sushiX < vertPath1X+2)){
          counter1++;
          leftPathDown = true;
          println("aaaaaaaaaaa");
        }
      }
    } else if(key == 'k'){
      if(!player2Blocked){
        if((sushiX > vertPath2X-2) && (sushiX < vertPath2X+2)){
          counter2++;
          rightPathDown = true;
        }
      }
    } else if(key == 's'){
      player2Blocked = true;
    } else if(key == 'l'){
      player1Blocked = true;
    }
  }
  
  if(sushiType == 1){
    rightPathDownEgg = rightPathDown;
    leftPathDownEgg = leftPathDown;
  }
  else if(sushiType == 2){
    rightPathDownrice = rightPathDown;
    leftPathDownRice = leftPathDown;
  }
  else if(sushiType == 3){
    rightPathDownMaki = rightPathDown;
    leftPathDownMaki = leftPathDown;
  }

  //position incrementation for egg..........................................................................
  if(leftPathDownEgg){
    if(sushiY <= 39){
      sushiY++;
      sushiX--;
    } else {
      //return to initial position
      leftPathDownEgg = false;
    }
  }else if(rightPathDownEgg){ //rightPathDown stays true for the 3 sushis !
    if(sushiY <= 39){
      sushiY++;
      sushiX++;
    } else {
      //return to initial position
      rightPathDownEgg = false;
    }
  }else{
    sushiX++;
    //println("111");
  }
  //position incrementation for rice....................................................................................
  if(leftPathDownRice){
    if(sushiY <= 39){
      sushiY++;
      sushiX--;
    } else {
      //return to initial position
      leftPathDownRice = false;
    }
  }else if(rightPathDownrice){ //rightPathDown stays true for the 3 sushis !
    if(sushiY <= 39){
      sushiY++;
      sushiX++;
    } else {
      //return to initial position
      rightPathDownrice = false;
      //sushiY= horizPathY;
      //sushiX=-9;
    }
  }else{
    sushiX++;
    //println("111");
  }
  //position incrementation for maki...........................................................................................
  if(leftPathDownMaki){
    if(sushiY <= 39){
      sushiY++;
      sushiX--;
    } else {
      //return to initial position
      leftPathDownMaki = false;
    }
  }else if(rightPathDownMaki){ //rightPathDown stays true for the 3 sushis !
    if(sushiY <= 39){
      sushiY++;
      sushiX++;
    } else {
      //return to initial position
      rightPathDownMaki = false;
    }
  }else{
    sushiX++;
    //println("111");
  }
  
  
  if(sushiX > 39 || sushiY > 39){
    sushiX = -22;
  }
  

  stroke(black);
  imageMode(CENTER);
  image(sushi_img, sushiX, sushiY);
 
  tab[0] = sushiX;
  tab[1] = sushiY;
  
  return tab;
}

void barrierDisplay(){
  if(player1Blocked){
    stroke(green);
    line(TOTAL_WIDTH/2-pathWidth, horizPathY+pathWidth/2, TOTAL_WIDTH/2, horizPathY+pathWidth/2);
  }
  if(player2Blocked){
    stroke(red);
    line(TOTAL_WIDTH/2+pathWidth, horizPathY+pathWidth/2, TOTAL_WIDTH/2, horizPathY+pathWidth/2);
  }
}