import processing.serial.*;

final int TOTAL_WIDTH  = 32;
final int TOTAL_HEIGHT = 32;
final int NUM_CHANNELS = 3;
final int BAUD_RATE    = 921600;

int currentScene = 1;

Serial serial;
byte[]buffer;

PImage monster_img;
PImage win_img;

void setup() {
  size(32, 32);
  
  monster_img = loadImage("monster.png");  
  win_img = loadImage("win.png");

  buffer = new byte[TOTAL_WIDTH * TOTAL_HEIGHT * NUM_CHANNELS];

  String[] list = Serial.list();
  printArray(list);
  
  try {
    //final String PORT_NAME = "/dev/cu.usbserial-02B60E77";
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
  }else if(key == '4'){
    currentScene = 4;
    setupScene4();
  }
}

void draw() {    
  if (currentScene == 1) {
    drawScene1();
  } else if (currentScene == 2) {
    drawScene2();
  } else if (currentScene == 3) {
    drawScene3();
  } else if (currentScene == 4) {
    drawScene4();
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
}

//scene 1

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


//scene2
int platesDiameter = 10;
int plateX = 6;
int plateY1 = 7;
int plateY2 = 25;

int crossX = 15;
int secondVerticalLineX = 21;
int pathHalfWidth = 3;

int makiX = crossX+3;
int makiY = 7;
int makiWidth = 4;
int makiHeight = 8;

void setupScene2(){
  background(0);
  //fill(random(255), random(255), random(255));
  //text("2", width/3, 18);  
  //ellipse(random(width), random(height), 10, 10);  
}

void drawScene2(){
  background(0);
  stroke(0,0,255);
  //vertical lines near plates
  line(crossX,0,crossX,plateY1-pathHalfWidth);
  line(crossX,plateY1+pathHalfWidth,crossX,plateY2-pathHalfWidth);
  line(crossX,plateY2+pathHalfWidth,crossX,32);
  //vertical lines
  line(secondVerticalLineX,0,secondVerticalLineX,32);
  
  //horizontal lines
  line(crossX,plateY1+pathHalfWidth,plateY1,plateY1+pathHalfWidth);
  line(crossX,plateY1-pathHalfWidth,plateY1,plateY1-pathHalfWidth);
  line(crossX,plateY2+pathHalfWidth,plateY1,plateY2+pathHalfWidth);
  line(crossX,plateY2-pathHalfWidth,plateY1,plateY2-pathHalfWidth);
  
  //plates
  stroke(255);
  ellipse(plateX,plateY1,platesDiameter,platesDiameter);
  ellipse(plateX,plateY2,platesDiameter,platesDiameter);
  //maki
  stroke(255);
  fill(204, 102, 0);
  rectMode(CENTER);
  ellipse(makiX,makiY, makiWidth, makiHeight);
  stroke(0);
  line(makiX-1, plateY1,makiX+1,plateY1);
  makiY++;
}

//scene3

void setupScene3(){
  background(0);
  fill(random(255), random(255), random(255));
  text("3", width/3, 18);  
  
}

void drawScene3(){
  image(monster_img, 24, 12, 10, 10);
}

//scene4

void setupScene4(){
  background(0);
  imageMode(CENTER);
  image(win_img, width/2, height/2, 20, 20);
}

void drawScene4(){
}