import controlP5.*;

ControlP5 cp5;

void setUpUI(){
  cp5 = new ControlP5(this);
  
  // create a new button with name 'buttonA'
  cp5.addButton("ChangePhoto")
     .setValue(0)
     .setPosition(800,400)
     .setSize(200,19)
     ;
  
  // and add another 2 buttons
  cp5.addButton("SentColor")
     .setValue(100)
     .setPosition(800,440)
     .setSize(200,19)
     ;
     

}


public void SentColor(int theValue) {
  //println("a button event from colorA: "+theValue);
  //c1 = c2;
  //c2 = color(0,160,100);
  SampleAndSent();
}

public void ChangePhoto(int theValue) {
  loadedImg = list.getRandom();
  //println("a button event from colorB: "+theValue);
  //c1 = c2;
  //c2 = color(150,0,0);
}
