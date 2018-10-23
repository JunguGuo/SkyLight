#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
  #include <avr/power.h>
#endif

#define PIN 6
Adafruit_NeoPixel strip = Adafruit_NeoPixel(12, PIN, NEO_GRB + NEO_KHZ800);
//-----bluetooth----
#include<SoftwareSerial.h>

#define TxD 3
#define RxD 2
//#define LED_PIN 13

SoftwareSerial bluetoothSerial(TxD, RxD);
//--------

String inString = "";    // string to hold input
String test = "12:44:123:34:66:78:123:222:9:1:2:4:12:44:123:34:66:78:123:222:9:1:2:4:12:44:123:34:66:78:123:222:9:1:2:4:";//must end with ':'
void setup() {
  // Open serial communications and wait for port to open:
  bluetoothSerial.begin(9600);
  //Serial.begin(9600);

  strip.begin();
  strip.show(); // Initialize all pixels to 'off'

  //parseCommand(test);

}

void loop() {
  // Read serial input:
  while (bluetoothSerial.available() > 0) {//bluetoothSerial.available()
    int inChar = bluetoothSerial.read();//bluetoothSerial.read();
    if (inChar!= '\n') {
      //Serial.print(inChar);
      // convert the incoming byte to a char and add it to the string:
      inString += (char)inChar;
    }
    // if you get a newline, print the string, then the string's value:
    if (inChar == '\n') {

      //echo the command back
//      Serial.print("String: ");
//      Serial.println(inString);
        bluetoothSerial.println("x"); //indicate processing to send the next command//bluetoothSerial.println("x");bbbbbbbbbb
      
       parseCommand(inString);
//      String xval = getValue(inString, ':', 0);
//      String yval = getValue(inString, ':', 2);
//      String zval = getValue(inString, ':', 4);
//      
//      Serial.print("X:" + xval);
//      Serial.print("Y:" + yval);
//      Serial.println("Z:" + zval);
      
      // clear the string for new input:
      inString = "";
    }
  }

  //parseCommand(test);


}


String getValue(String data, char separator, int index)
{
    int found = 0;
    int strIndex[] = { 0, -1 };
    int maxIndex = data.length() - 1;

    for (int i = 0; i <= maxIndex && found <= index; i++) {
        if (data.charAt(i) == separator || i == maxIndex) {
            found++;
            strIndex[0] = strIndex[1] + 1;
            strIndex[1] = (i == maxIndex) ? i+1 : i;
        }
    }
    return found > index ? data.substring(strIndex[0], strIndex[1]) : "";
}

void parseCommand(String com){
//  String part1 = com.substring(0,com.indexOf(" "));
//  String part2 = com.substring(com.indexOf(" ")+1);  

  int i = 0;
  int id = 0;
  while(i!= com.length()){
  int index = com.indexOf(":",i+1);
  String R = com.substring(i,index);
  int index2 = com.indexOf(":",index+1);
  String G = com.substring(index+1,index2);
  index = com.indexOf(":",index2+1);
  String B = com.substring(index2+1,index);

  i = index+1;
  strip.setPixelColor(id, strip.Color(R.toInt(), G.toInt(), B.toInt()));
//    Serial.print("id: ");Serial.print(id);
//  Serial.println(" | R: "+R + " | G: "+G + " | B: "+B);
  id++;
  //Serial.println(i);
  }
strip.show();
delay(20);

  
}
