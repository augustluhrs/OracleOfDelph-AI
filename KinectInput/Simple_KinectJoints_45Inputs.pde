/* --------------------------------------------------------------------------
 * Simple_KinectJoints_45Inputs
 * --------------------------------------------------------------------------
 * 
 * Inputs: 1 user x 15 joints x 3 coordinates = 45 inputs
 * (note: this version works only with one user (closest one))
 * 
 * How to use: 
 *  - Start Wekinator, set inputs to 45 and set outputs as you want
 *  - Click "Start Listening"
 *  - Before clicking "Next" run this sketch (this order is important so that Wekinator's input names are set to corresponding joint names)
 *  - Click "Next"
 *  - Click View -> Inputs to see incoming OSC messages with joint names
 *  - You could simply test with one joint (eg. hand, torso...): go to View -> Input/output connection editor -> Actions -> Disconnect all -> select joint's coordinates that you want to track
 * --------------------------------------------------------------------------
 * Author:  Milos Roglic / www.milosroglic.com
 * Date:    02/21/2016 (m/d/y)
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

SimpleOpenNI kinect;

int[] jointNames;
String[] wekinatorJointNames;

void setup() {
  size(640, 480);
  
  kinect = new SimpleOpenNI(this);
  if(kinect.isInit() == false) {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;
  }

  // initialize joins array with all skeleton joints
  initJointNames(); 
  
  // enable depthMap generation
  kinect.enableDepth();
   
  // enable skeleton generation for all joints
  kinect.enableUser();
 
  background(200,0,0);

  stroke(0,0,255);
  strokeWeight(3);
  smooth();

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 9000);
  dest = new NetAddress("127.0.0.1", 6448);

  sendInputNames();
}

void draw(){
  // update the cam
  kinect.update();
  
  // draw depthImageMap
  image(kinect.depthImage(),0,0);
  //image(kinect.userImage(), 0, 0);
  
  int userId = findClosestUser();
  if (userId > -1){
    drawSkeleton(userId);
    drawJoints(userId);    
  }

  sendOsc(userId);
}

void sendOsc(int userId){  
  OscMessage msg = new OscMessage("/wek/inputs");
  
  if (userId > -1){
    for (int i = 0; i < jointNames.length; i++){
      PVector realWorld = getRealWorldJointPos(userId, jointNames[i]);
      msg.add(realWorld.x);
      msg.add(realWorld.y);
      msg.add(realWorld.z);
    }
  }
  // no user -> reset joint positions
  else{     
    for (int i = 0; i < jointNames.length; i++){
      msg.add(0.);  // reset x
      msg.add(0.);  // reset y
      msg.add(0.);  // reset z
    }
  }

  oscP5.send(msg, dest);
}

// ========= Find closest user to Kinect =========

// finds user that is closest to Kinect (or returns -1 if there is no tracked user)
int findClosestUser(){
  int closestUserId = -1;
  float closestUserZ = 8000; // distance in mm - more than Kinect can see

  int[] userList = kinect.getUsers();
  for(int i = 0; i < userList.length; i++){
    int userId = userList[i];
    if(kinect.isTrackingSkeleton(userId)){
      PVector torso = getRealWorldJointPos(userId, SimpleOpenNI.SKEL_TORSO);
      if (torso.z < closestUserZ){
        closestUserZ = torso.z;
        closestUserId = userId;
      }      
    }
  }

  return closestUserId;
}

// ========= Draw Skeleton =========

void drawSkeleton(int userId){
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
}

// ========= Draw Joints =========

void drawJoints(int userId){
  for(int i = 0; i < jointNames.length; i++){
    drawJoint(userId, jointNames[i]);
  }  
}

void drawJoint(int userId, int jointType){
  PVector realWorld = getRealWorldJointPos(userId, jointType);
  PVector projective = getProjectiveJointPos(realWorld);
  ellipse(projective.x, projective.y, 10, 10);
}

// returns 3D joint position (world position)
PVector getRealWorldJointPos(int userId, int jointType){
  PVector realWorld = new PVector();
  kinect.getJointPositionSkeleton(userId, jointType, realWorld);
  return realWorld; 
}

// returns 2D joint position (screen(projective) position)
PVector getProjectiveJointPos(PVector realWorld){
  PVector projective = new PVector();
  kinect.convertRealWorldToProjective(realWorld, projective);
  return projective;
}

// ========= SimpleOpenNI events =========

void onNewUser(SimpleOpenNI curkinect, int userId){
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curkinect.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curkinect, int userId){
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curkinect, int userId){
  //println("onVisibleUser - userId: " + userId);
}

void keyPressed(){
  switch(key){
    case ' ':
      kinect.setMirror(!kinect.mirror());
      break;
  }
}

// ========= Init joint names =========

void initJointNames(){
  jointNames = new int[15];
  jointNames[0] = SimpleOpenNI.SKEL_HEAD;
  jointNames[1] = SimpleOpenNI.SKEL_NECK;
  jointNames[2] = SimpleOpenNI.SKEL_LEFT_SHOULDER;
  jointNames[3] = SimpleOpenNI.SKEL_LEFT_ELBOW;
  jointNames[4] = SimpleOpenNI.SKEL_LEFT_HAND;
  jointNames[5] = SimpleOpenNI.SKEL_RIGHT_SHOULDER;
  jointNames[6] = SimpleOpenNI.SKEL_RIGHT_ELBOW;
  jointNames[7] = SimpleOpenNI.SKEL_RIGHT_HAND;
  jointNames[8] = SimpleOpenNI.SKEL_TORSO;
  jointNames[9] = SimpleOpenNI.SKEL_LEFT_HIP;
  jointNames[10] = SimpleOpenNI.SKEL_LEFT_KNEE;
  jointNames[11] = SimpleOpenNI.SKEL_LEFT_FOOT;
  jointNames[12] = SimpleOpenNI.SKEL_RIGHT_HIP;
  jointNames[13] = SimpleOpenNI.SKEL_RIGHT_KNEE;
  jointNames[14] = SimpleOpenNI.SKEL_RIGHT_FOOT;
}

// order of names in wekinatorJointNames must be the same as order of names in jointNames
void initWekinatorJointNames(){
  wekinatorJointNames = new String[15];
  wekinatorJointNames[0] = "HEAD";
  wekinatorJointNames[1] = "NECK";
  wekinatorJointNames[2] = "LEFT_SHOULDER";
  wekinatorJointNames[3] = "LEFT_ELBOW";
  wekinatorJointNames[4] = "LEFT_HAND";
  wekinatorJointNames[5] = "RIGHT_SHOULDER";
  wekinatorJointNames[6] = "RIGHT_ELBOW";
  wekinatorJointNames[7] = "RIGHT_HAND";
  wekinatorJointNames[8] = "TORSO";
  wekinatorJointNames[9] = "LEFT_HIP";
  wekinatorJointNames[10] = "LEFT_KNEE";
  wekinatorJointNames[11] = "LEFT_FOOT";
  wekinatorJointNames[12] = "RIGHT_HIP";
  wekinatorJointNames[13] = "RIGHT_KNEE";
  wekinatorJointNames[14] = "RIGHT_FOOT";
}

// ========= Configure Wekinator input names =========

// sendInputNames should be called at start (in setup()) to configure input names in Wekinator
void sendInputNames(){
  OscMessage msg = new OscMessage("/wekinator/control/setInputNames");

  initWekinatorJointNames();
  String coordinates[] = {"_x", "_y", "_z"};  

  int n = 0;
  for (int i = 0; i < wekinatorJointNames.length; i++) {
    for (int j = 0; j < coordinates.length; j++) {     
      msg.add(wekinatorJointNames[i] + coordinates[j]); 
      n++;
    }
  }

  oscP5.send(msg, dest); 
  println("Sent joint names " + n);
}
