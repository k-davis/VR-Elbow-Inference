// 111601 frames

import peasy.*;
import java.util.*;

String postProcessedDataPath = "80_postproc_full.json";

PeasyCam cam;
float scale = 50;
MocapData dataController;
DrawingStrategy drawer;

void setup() {
  size(1000,1000,P3D);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
  cam.setSuppressRollRotationMode();
  
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
            cameraZ/100.0, cameraZ*10.0);
  
  
  dataController = new MocapData(postProcessedDataPath);
  drawer = new Points();
}

void draw() {
  noLights();
  noStroke(); 
  background(255);
  println(frameRate);
  
  translate(-scale/2, scale/2, -scale/2);
    
  drawUtilityObjects();
  dataController.display();
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
