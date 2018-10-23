import oscP5.*;
import netP5.*;
int InPort = 3334;
int OutPort = 12000;
OscP5 oscP5;
NetAddress myRemoteLocation;

void setupOSC(int inPort, int outPort ){
  oscP5 = new OscP5(this,inPort);
  myRemoteLocation = new NetAddress("127.0.0.1",outPort);
}

void oscSend(){//mousePressed()
    OscMessage myMessage = new OscMessage("/test");
  
  myMessage.add(123); /* add an int to the osc message */
  myMessage.add(12.34); /* add a float to the osc message */
  myMessage.add("some text"); /* add a string to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}

void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  
  if(theOscMessage.checkAddrPattern("/test")==true) {
    /* check if the typetag is the right one. */
    if(theOscMessage.checkTypetag("s")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      //int firstValue = theOscMessage.get(0).intValue();  
      //float secondValue = theOscMessage.get(1).floatValue();
      String value = theOscMessage.get(0).stringValue();
      print("### received an osc message /test with typetag s.");
      println(" values: "+value);
      SerialSent(value);
      return;
    }  
  } 
  println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}
