// 111601 frames

import peasy.*;
import java.util.*;


String postProcessedDataPath = "80_postproc_full.json";

ChildApplet child;
PeasyCam cam;
float scale = 50;
MocapData dataController;
DrawingStrategy drawer;


String JOINT_A = "lradius";
String JOINT_B = "lhumerus";

void settings(){
   size(800, 800,P3D);
   smooth();
}

void setup() {
  child = new ChildApplet();
  
  surface.setTitle("Controller");
 
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(25);
  cam.setMaximumDistance(500);
  cam.setSuppressRollRotationMode();
  
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
            cameraZ/100.0, cameraZ*10.0);
  
  
  dataController = new MocapData(postProcessedDataPath);
  drawer = new DrawPoints();
}

void draw() {
  noLights();
  noStroke(); 
  background(255);
  
  translate(-scale/2, scale/2, -scale/2);
  
  cam.setWheelHandler(new MyHandler(cam.getWheelHandler()));
    
  drawUtilityObjects();
  drawer.drawPoints(dataController);
}

void keyPressed(){
 if(key == ' '){
   drawer.handleToggleDrawAmount(); 
 }
}


void drawUtilityObjects() { 
   // draw floor plane
   pushMatrix();
   fill(200);
   translate(scale/2, 0, scale/2);
   box(scale, 0.0001, scale);
   popMatrix();
   
   // draw wireframe box
   pushMatrix();
   noFill();
   stroke(0);
   translate(scale/2, -scale/2, scale/2);
   box(scale);
   popMatrix();
   
   noStroke();
   
   // draw rgb axis guides
   pushMatrix();
   fill(255, 0, 0);
   translate(scale/2, 0, 0);
   box(scale, 1, 1);
   popMatrix();
   
   pushMatrix();
   fill(0, 255, 0);
   translate(0, -scale/2, 0);
   box(1, scale, 1);
   popMatrix();
   
   pushMatrix();
   fill(0, 0, 255);
   translate(0, 0, scale/2);
   box(1, 1, scale);
   popMatrix();
}
