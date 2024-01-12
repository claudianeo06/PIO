/**
 * Sushi Battle by Claudia Neo and Kristina Greco
 */

import processing.serial.*;
import processing.sound.*;
SoundFile gameMusic;
SoundFile winSound;

final int TOTAL_WIDTH  = 32;
final int TOTAL_HEIGHT = 32;
final int NUM_CHANNELS = 3;
final int BAUD_RATE    = 921600;

Serial serial;
byte[]buffer;

//images
PImage sushibattle_img;
PImage presstostart_img;
PImage scene1maki_img;
PImage background_img;
PImage win_img;
PImage egg_img;
PImage maki_img;
PImage salmon_img;

PFont sushiBattleFont;


//confetti
Confetti[] flake;

int currentScene = 1;

//colors
color main = color(237,224,207);
color red = color(255,0,0);
color orange = color(255, 160, 0);
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
boolean downOksalmon = false;
boolean downOkmaki = false;

int sushiX = 10;
int sushiY = horizPathY;
boolean leftPathDown = false;
boolean rightPathDown = false;

boolean rightPathDownEgg = false;
boolean leftPathDownEgg = false;
boolean rightPathDownsalmon = false;
boolean leftPathDownsalmon = false;
boolean rightPathDownMaki = false;
boolean leftPathDownMaki = false;

int tab []= new int [2];
int tab2 []= new int [2];
  
int sushiType; //1,2,3

//game running
boolean isGameRunning = true;

int interval1 = 2000; 
int interval2 = 4000;
int interval3 = 6000; 
int lastTimeSwitch = 0;

  
void setup() {
  size(32, 32);
  
  frameRate(10);
  
  sushibattle_img = loadImage("sushiBattle.png");  
  presstostart_img = loadImage("presstostart.png");
  scene1maki_img = loadImage("scene1maki.png");
  background_img = loadImage("background.png");
  win_img = loadImage("win.png");  
  egg_img = loadImage("egg.png");  
  salmon_img = loadImage("salmon.png");  
  maki_img = loadImage("maki.png"); 
  
  gameMusic = new SoundFile(this, "gameMusic.mp3");
  winSound = new SoundFile(this, "winSound.wav");
  
  sushiBattleFont = createFont("Arial Bold", 8);
 
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

}
 
void keyPressed(){
  if(currentScene ==1 && (key =='a' || key == 'k' || key == 's' || key == 'l')){
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
    drawScene1();
  }else if (currentScene == 2) {
    drawScene2();
  } else if (currentScene == 3) {
    drawScene3();
  }
  
  // -------------------------------------------------------------------------------------------------------------------------------------------------
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
  lastTimeSwitch = millis();
  //counter1 = 0;
  //counter2 = 0;
  //isGameRunning = true;
  //sushiX = 10;
  //sushiY = horizPathY;
  //leftPathDown = false;
  //rightPathDown = false;
  //eggX = -10;
  //eggY = horizPathY;
  //salmonX = -30;
  //salmonY = horizPathY;
  //makiX = -50;
  //makiY = horizPathY;
  //tab[0] = 0;
  //tab[1] = 0;
  //tab2[0] = 0;
  //tab2[1] = 0;
  
  //rightPathDownEgg = false;
  //leftPathDownEgg = false;
  //rightPathDownsalmon = false;
  //leftPathDownsalmon = false;
  //rightPathDownMaki = false;
  //leftPathDownMaki = false;
  
  //.............................................
  
  eggX = -10;
eggY = horizPathY;
salmonX = -30;
salmonY = horizPathY;
makiX = -50;
makiY = horizPathY;

//counters
counter1 = 0;
counter2 = 0;

//blocking part
player1Blocked = false;
player2Blocked = false;

downOk = false;
downOkEgg = false;
downOksalmon = false;
downOkmaki = false;

sushiX = 10;
sushiY = horizPathY;
leftPathDown = false;
rightPathDown = false;

rightPathDownEgg = false;
leftPathDownEgg = false;
rightPathDownsalmon = false;
leftPathDownsalmon = false;
rightPathDownMaki = false;
leftPathDownMaki = false;

tab[0] = 0;
tab[1] = 0;
tab2[0] = 0;
tab2[1] = 0;
}

void drawScene1(){
  int currentTime = millis();

  if (currentTime - lastTimeSwitch > interval3) {
    displayFirstThing();
    lastTimeSwitch = currentTime; 
  } else if (currentTime - lastTimeSwitch > interval2) {
    displayThirdThing();
  } else if (currentTime - lastTimeSwitch > interval1) {
    displaySecondThing();
  } else {
    displayFirstThing();
  }
}

void displayThirdThing() {
  background(black);
  imageMode(CENTER);
  image(presstostart_img,  width/2, height/2, 32, 32);
}

void displaySecondThing() {
  background(black);
  imageMode(CENTER);
  image(scene1maki_img, width/2, height/2, 32, 32);
}

void displayFirstThing(){
  background(black);
  imageMode(CENTER);
  image(sushibattle_img,  width/2, height/2, 32, 32);
}

void setupScene2(){
  gameMusic.play();
  gameMusic.loop();
}

void drawScene2(){
  background(0);
  imageMode(CENTER);
  image(background_img, width/2,height/2); //size : ,40,32
  
  //egg
  sushiType = 1;
  tab2 = sushiMove(sushiType, eggX, eggY, egg_img);
  eggX = tab2[0];
  eggY = tab2[1];
  //salmon
  sushiType = 2;
  tab2 = sushiMove(sushiType, salmonX, salmonY, salmon_img);
  salmonX = tab2[0];
  salmonY = tab2[1];
  //maki
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
  
  if((counter1 == 3) || (counter2 == 3)){//14
    currentScene = 3;
    setupScene3();
  } 
}


void setupScene3(){
  background(0);
  gameMusic.pause();
  winSound.play();

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
    setupScene1();
  }
}
 
 
int[] sushiMove(int sushiType2, int sushiX, int sushiY, PImage sushi_img){
  if(keyPressed){
    if(key == 'a'){
      if(!player1Blocked && !player2Blocked){
        if((sushiX > vertPath1X+3) && (sushiX < vertPath1X+7)){
          counter1++;
          leftPathDown = true;
        }
      }
    } else if(key == 'k'){
      if(!player2Blocked && !player1Blocked){
        if((sushiX > vertPath2X-7) && (sushiX < vertPath2X-3)){
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

  if(sushiType2 == 1 && !rightPathDownEgg && !leftPathDownEgg){
    rightPathDownEgg = rightPathDown;
    leftPathDownEgg = leftPathDown;
  }
  else if(sushiType2 == 2 && !rightPathDownsalmon && !leftPathDownsalmon){
    rightPathDownsalmon = rightPathDown;
    leftPathDownsalmon = leftPathDown;
  }
  else if(sushiType2 == 3 && !rightPathDownMaki && !leftPathDownMaki){
    rightPathDownMaki = rightPathDown;
    leftPathDownMaki = leftPathDown;
  }
  rightPathDown = false;
  leftPathDown = false;

  //position incrementation for egg........................................................................................................................
  if(leftPathDownEgg && sushiType == 1){
    if(sushiY < 34){
      sushiY++;
      sushiX--;
    } else {
      sushiY++;
      sushiX--;
      leftPathDownEgg = false;
    }
  }else if(rightPathDownEgg && sushiType == 1){
    if(sushiY < 34){
      sushiY++;
      sushiX++;
    } else {
      sushiY++;
      sushiX++;
      rightPathDownEgg = false;
    }
  }
  //position incrementation for salmon.......................................................................................................................
  else if(leftPathDownsalmon && sushiType == 2){
    if(sushiY < 34){
      sushiY++;
      sushiX--;
    } else {
      sushiY++;
      sushiX--;
      leftPathDownsalmon = false;
    }
  }else if(rightPathDownsalmon && sushiType == 2){
    if(sushiY < 34){
      sushiY++;
      sushiX++;
    } else {
      sushiY++;
      sushiX++;
      rightPathDownsalmon = false;
    }
  }
  //position incrementation for maki......................................................................................................................
  else if(leftPathDownMaki && sushiType == 3){
    if(sushiY < 34){
      sushiY++;
      sushiX--;
    } else {
      sushiY++;
      sushiX--;
      leftPathDownMaki = false;
    }
  }else if(rightPathDownMaki && sushiType == 3){
    if(sushiY < 34){
      sushiY++;
      sushiX++;
    } else {
      sushiY++;
      sushiX++;
      rightPathDownMaki = false;
    }
  }else{
    sushiX++;
  }
  if((sushiX > 50 || sushiY > 34)){
    sushiX = -22;
    sushiY = horizPathY;
  }
  
  println("sushiXY");
  println(sushiX);
  println(sushiY);
  
  stroke(black);
  imageMode(CENTER);
  image(sushi_img, sushiX, sushiY);
 
  tab[0] = sushiX; //à enregistrer en tant que makiX ou eggX,... (le return est inutile)
  tab[1] = sushiY;
  
  return tab;
}

void barrierDisplay(){
  if(player1Blocked){
    stroke(green);
    line(TOTAL_WIDTH/2-pathWidth, horizPathY+pathWidth/2, TOTAL_WIDTH/2-1, horizPathY+pathWidth/2);
  }
  if(player2Blocked){
    stroke(red);
    line(TOTAL_WIDTH/2+pathWidth-1, horizPathY+pathWidth/2, TOTAL_WIDTH/2, horizPathY+pathWidth/2);
  }
}