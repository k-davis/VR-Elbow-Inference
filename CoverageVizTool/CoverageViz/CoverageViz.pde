// 111601 frames

import peasy.*;
import java.util.*;

public final float[] LCLAVICLE = {0.61, -0.50, 0.5};
public final float[] RCLAVICLE = {0.39, -0.50, 0.50};
public final float[] THORAX = {0.5, -0.45, 0.5};
   
String postProcessedDataPath = "80_postproc_full.json";

ChildApplet child;

float scale = 50;
MocapData dataController;
Controller controller;


String JOINT_A = "lradius";
String JOINT_B = "lhumerus";

void settings(){
   size(800, 800,P3D);
   smooth();
}

void setup() {
  child = new ChildApplet();
  
  surface.setTitle("Controller");
   
  controller = new Controller(this);
  controller.setup();
  
  dataController = new MocapData(postProcessedDataPath);
}

void draw() {
  noLights();
  noStroke(); 
  background(255);
  
  translate(-scale/2, scale/2, -scale/2);
      
  //drawUtilityObjects();
  controller.draw();
}

void keyPressed(){
 if(key == ' '){
   controller.handleToggleDrawAmount(); 
 }
}
