class Confetti{
  float x, y;
  float vy;
  String style;
  float size;
  
  //String[] styles = {"|", "/", "*"};
  
  Confetti(){
    radomize();
  }
  
  void radomize(){
    x = random(width);
    y = -random(height);
    //style = styles[int(random(styles.length))];
    //style = rect(10,10,10,10);
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
    //textSize(size);
    //text(style, x, y);
    rect(x,y,1,2);
  }
  
}
