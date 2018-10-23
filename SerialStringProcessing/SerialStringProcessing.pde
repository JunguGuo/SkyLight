/**
 * Simple Write. 
 * 
 * Check if the mouse is over a rectangle and writes the status to the serial port. 
 * This example works with the Wiring / Arduino program that follows below.
 */


import processing.serial.*;
import processing.video.*;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port
PImage img;
Movie movie;
int resolution = 12;
boolean testMode = false;
boolean useMovie = false;
//boolean useFileImage = true;
boolean readySent = true;
boolean movieFeed = false;
boolean collectionPicMode = true;
float moviePlayPos = 0.0;
void setup() 
{
  size(960, 540);
  setupOSC(InPort, OutPort );
  setUpUI();
  drop = new SDrop(this);

  println(Serial.list());
  String portName = "/dev/cu.HC-05-DevB";//Serial.list()[5];//"/dev/cu.usbmodem14511"
  if (!testMode) {
    myPort = new Serial(this, portName, 9600);//"/dev/cu.HC-05-DevB", 38400
    myPort.bufferUntil('\n');
  }

  //img = loadImage("test3.jpg");
  if (useMovie) {
    movie = new Movie(this, "movie.mp4");

    movie.play();
    movie.jump(moviePlayPos);
  }

  //fileimageload
  loader = new FileImageLoader(this);
  list = loader.start(path);
  
  //files = listFiles(userpath);
  //lastSize = files.length;
  file = new File(userpath);
  lastSize = file.listFiles().length;
  println(lastSize);
  
  //userlist = loader.start(userpath);

}
color[] cols;
void draw() {

  //if ( CheckNewUserImage()) {
  //  userloadedImg = userlist.getMostRecentImage();
  //  img = userloadedImg.getImg();
  //  collectionPicMode = false;
  //}

  if (collectionPicMode) {   
    if (loadedImg == null) {
      loadedImg = list.getRandom();
    } else {
      img = loadedImg.getImg();
    }
  }
  
  

  if (img !=null) {
    img.resize(width,height);
    image(img, 0, 0, width, height);
  }


  showDebugColors(cols);
  showSampleStrip();
  //println(readySent);
}

void keyReleased() {
  if (key == ' ') {
    //myPort.write("12:44:123:34:66:78:123:222:9:1:2:4:12:44:123:34:66:78:123:222:9:1:2:4:12:44:123:34:66:78:123:222:9:1:2:4:\n");

    SampleAndSent();
    //img = loadImage("test2.jpg");
  }
  if (key == 'm')
    movieFeed = true;
}

void movieEvent(Movie movie) {
  movie.read();
  img = movie.get( 0, 0, movie.width, movie.height);

  if (movieFeed)
    SampleAndSent();
}

void serialEvent(Serial myPort) {
  String input = myPort.readString();
  println(input);
  if (input.length()>0)
    readySent = true;
  //myPort.write('x');
}

void SampleAndSent() {
  cols = SampleColor(resolution, img, true);
  String s = Colors2String(cols);
  SerialSent (s);
}

void SerialSent(String msg) {
  if (!testMode && readySent) {
    myPort.write(msg);
    readySent = false;
    //img = loadImage("test2.jpg");
  }
}
