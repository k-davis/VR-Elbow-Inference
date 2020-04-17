// 111601 frames

import peasy.*;
import java.util.*;


public final float[] LCLAVICLE = {0.61, -0.50, 0.5};
public final float[] RCLAVICLE = {0.39, -0.50, 0.50};
public final float[] THORAX = {0.5, -0.45, 0.5};
   
String postProcessedDataPath = "80_postproc_full.json";

ChildApplet child;

float scale = 50;
MocapData dataHolder;
Controller controller;
EventManager eventManager;
SphereRegion selector;

String JOINT_A = "lradius";
String JOINT_B = "lhumerus";

void settings(){
   size(800, 800,P3D);
   noSmooth();
}

void setup() {
  eventManager = new EventManager();
  
  child = new ChildApplet();
  
  surface.setTitle("Controller");
   
  controller = new Controller(this);
  controller.setup();
  
  dataHolder = new MocapData(postProcessedDataPath);
}

void draw() {
  noLights();
  noStroke(); 
  background(255);
  
  translate(-scale/2, scale/2, -scale/2);
      
  controller.draw();
}

void keyPressed(){
  
  switch(key){
    case ' ':
      eventManager.trigger(Events.SPACE_PRESS);
      break;
    case 'w':
    case 'W':
      eventManager.trigger(Events.W_PRESS);
      break;
    case 'a':
    case 'A':
      eventManager.trigger(Events.A_PRESS);
      break;
    case 's':
    case 'S':
      eventManager.trigger(Events.S_PRESS);
      break;
    case 'd':
    case 'D':
      eventManager.trigger(Events.D_PRESS);
      break;
    case 'q':
    case 'Q':
      eventManager.trigger(Events.Q_PRESS);
      break;
    case 'z':
    case 'Z':
      eventManager.trigger(Events.Z_PRESS);
      break;
  };
  
  switch(keyCode){
    case 16:
      eventManager.trigger(Events.SHIFT_PRESS);
      break;
    case 17:
      eventManager.trigger(Events.CTRL_PRESS);
      break;
  };
}
