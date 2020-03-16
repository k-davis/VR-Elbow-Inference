/*
Processed-Data Visualizer

This program is meant to visually verify that 
the data preprocessor functions correctly. 

To use, run a mocap file through the preprocessor,
then compaire both the input and output files.
*/

import peasy.*;
import java.util.*;

String preProcessedDataPath = "../mocap_data/80/80_20.json";
String postProcessedDataPath = "80_postproc.json";

PeasyCam cam;
PreProcData predata;
PostProcData postdata;

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
  
  predata = new PreProcData(preProcessedDataPath);
  postdata = new PostProcData(postProcessedDataPath);
}

void draw() {
  lights();
  noStroke(); 
  background(255);
  
  drawUtilityObjects();
  
  predata.update();
  postdata.update();
}

void drawBall(float[] coords){
  drawBall(coords[0], coords[1], coords[2]);
}

void drawBall(float x, float y, float z){
   pushMatrix();
   translate(x, y, z);
   sphere(1);
   popMatrix();
}

void drawUtilityObjects() { 
   // draw floor plane
   pushMatrix();
   fill(200);
   translate(25, 0, 25);
   box(50, 0.0001, 50);
   popMatrix();
   
   // draw wireframe box
   pushMatrix();
   noFill();
   stroke(0);
   translate(25, -25, 25);
   box(50);
   popMatrix();
   
   noStroke();
   
   // draw rgb axis guides
   pushMatrix();
   fill(255, 0, 0);
   translate(25, 0, 0);
   box(50, 1, 1);
   popMatrix();
   
   pushMatrix();
   fill(0, 255, 0);
   translate(0, -25, 0);
   box(1, 50, 1);
   popMatrix();
   
   pushMatrix();
   fill(0, 0, 255);
   translate(0, 0, 25);
   box(1, 1, 50);
   popMatrix();
   
   // draw 0 and 1 points
   pushMatrix();
   fill(0);
   translate(0, 0, 0);
   sphere(2);
   popMatrix();
   
   pushMatrix();
   fill(255);
   translate(50, -50, 50);
   sphere(2);
   popMatrix();
}
