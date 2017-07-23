import oscP5.*;
import netP5.*;
OscP5 oscP5;
String[] words = { "Despair", "Death", "Sad", "Time", "Wine", "Stars", "Kiss", "Sweet", "Love", "Ecstasy"};

import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;

Robot robot;
String currentMessage = "";
boolean isRunning;


void setup(){
 size(400, 400);
 oscP5 = new OscP5(this, 12000);
 isRunning = false;
 try {
   robot = new Robot();
 }
 catch (AWTException e) {
   e.printStackTrace();
   exit();
 }
}

void draw() {
 background(255);
 fill(0);
 text("Receives 1 classifier output message from wekinator", 10, 10);
 text("Listening for OSC message /wek/outputs, port 12000", 10, 30);
 text("last message: " + currentMessage, 10, 180);
}

void writeString(String s, int delayStart, int delayBetween, int delayEnd, boolean enterAtEnd) {
 isRunning = true;
 robot.delay(delayStart);
 for (int i = 0; i < s.length(); i++) {
     char c = s.charAt(i);
     if (c == '_') {
       robot.keyPress(KeyEvent.VK_SHIFT);
       robot.keyPress(KeyEvent.VK_MINUS);
       robot.keyRelease(KeyEvent.VK_MINUS);
       robot.keyRelease(KeyEvent.VK_SHIFT);
       robot.delay(delayBetween);
     }
     else if (c == '>') {
       robot.keyPress(KeyEvent.VK_SHIFT);
       robot.keyPress(KeyEvent.VK_PERIOD);
       robot.keyRelease(KeyEvent.VK_PERIOD);
       robot.keyRelease(KeyEvent.VK_SHIFT);
       robot.delay(delayBetween);
     }
     else {
       if (Character.isUpperCase(c)) {
           robot.keyPress(KeyEvent.VK_SHIFT);
       }
       robot.keyPress(Character.toUpperCase(c));
       robot.keyRelease(Character.toUpperCase(c));
       robot.delay(delayBetween);
       if (Character.isUpperCase(c)) {
           robot.keyRelease(KeyEvent.VK_SHIFT);
       }
     }
 }
 robot.delay(delayEnd);
 if (enterAtEnd) {
   robot.keyPress(KeyEvent.VK_ENTER);
   robot.keyRelease(KeyEvent.VK_ENTER);
 }  
 isRunning = false;  
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 if (isRunning) {
   return;
 }
 if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
   if (theOscMessage.checkTypetag("ff")) {
     float f = theOscMessage.get(0).floatValue();
     int wordNumber= int(map(f, 0.0, 1.0, 0.0,9.0));
     println(wordNumber);
     //if (wordNumber == 0) {
       writeString("th sample.lua -checkpoint cv/allcheck8_34000.t7 -length 666 -start_text "+words[wordNumber]+" > output.txt; gedit output.txt", 1000, 100, 500, true);
         
        exit();
   }
 }
}

