class Confetti{
  float x, y;
  float vy;
  String style;
  float size;
  
  Confetti(){
    radomize();
  }
  
  void radomize(){
    x = random(width);
    y = random(height);
    vy = random(0.01, 0.1);
    size = random(5);
  }
  
  void fall(){
    x += random(-1,1);
    y += vy;
    if(y>height + 10) radomize();
  }
  
  void display(){
    noStroke();
    fill(random(255),random(255),random(255));
    rect(x,y,1,2);
  }
  
}
