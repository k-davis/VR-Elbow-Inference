import java.util.function.*;

abstract class DrawingStrategy { 
   protected boolean shouldDrawAll = false;
   protected PApplet window;
   protected String jointFocus;
   protected HighlightWhich highlightWhich; 
   
   
   abstract void drawPoints(MocapData data);
   
   public DrawingStrategy(PApplet window, String jointFocus, HighlightWhich which){
     this.window = window;
     highlightWhich = which;
     this.jointFocus = jointFocus;
   }
   
   public void handleToggleDrawAmount(){
      shouldDrawAll = !shouldDrawAll;
   }
   
   public void drawBall(float[] coords) {
     window.pushMatrix();
     window.translate(scale * coords[0], scale * coords[1], scale * coords[2]);
     window.sphere(1);
     window.popMatrix();
   }
   
   public void drawUtilityObjects() {
     PApplet w = this.window;
     w.lights();
    
     
     // draw floor plane
     w.pushMatrix();
     w.fill(200);
     w.translate(scale/2, 0, scale/2);
     w.box(scale, 0.0001, scale);
     w.popMatrix();
     
     // draw wireframe box
     w.pushMatrix();
     w.noFill();
     w.stroke(0);
     w.translate(scale/2, -scale/2, scale/2);
     w.box(scale);
     w.popMatrix();
     
     w.noStroke();
     
     // draw rgb axis guides
     w.pushMatrix();
     w.fill(255, 0, 0);
     w.translate(scale/2, 0, 0);
     w.box(scale, 1, 1);
     w.popMatrix();
     
     w.pushMatrix();
     w.fill(0, 255, 0);
     w.translate(0, -scale/2, 0);
     w.box(1, scale, 1);
     w.popMatrix();
     
     w.pushMatrix();
     w.fill(0, 0, 255);
     w.translate(0, 0, scale/2);
     w.box(1, 1, scale);
     w.popMatrix();
     
          
     // draw reference joints
     w.fill(255, 100, 100);
     drawBall(LCLAVICLE);
     w.fill(255, 200, 200);
     drawBall(RCLAVICLE);
     w.fill(255, 100, 100);
     drawBall(THORAX); 
  }
}

public enum HighlightWhich {
  DIRECT,
  CONTROLLER_LEAD
}



class DrawPoints extends DrawingStrategy {
   private float percentageToDraw = 0.2;
   
   public DrawPoints(PApplet window, String jointFocus, HighlightWhich which){
     super(window, jointFocus, which); 
   }
   
   public void drawPoints(MocapData data){
     int countToIgnore = (int) (1 / percentageToDraw);
     int countCycler = 0;
     
     window.noLights();
     
     Iterator<Frame> frameIt = data.iterator();
     
     while(frameIt.hasNext()) {
       Frame curFrame = frameIt.next();
       
       if(shouldDrawAll) {
          drawDataPoint(curFrame); 
          
       } else {
         if(countCycler % countToIgnore == 0) {
           drawDataPoint(curFrame);
         }
  
         countCycler++;
       }
     }
   }
   
   void drawDataPoint(Frame frame) {    

     float[] coordsForHighlightCheck;
     
     if(highlightWhich == HighlightWhich.DIRECT) {
        coordsForHighlightCheck = frame.getCoordsOfJoint(jointFocus); 
     } else {
        // HightlightWhich.CONTROLLER_LEAD
        coordsForHighlightCheck = frame.getCoordsOfJoint(controller.getJoint()); 
     }
     
     if(selector.isWithinRegion(coordsForHighlightCheck)){
        window.stroke(220, 0, 0);
     } else {
        window.stroke(000);
     }
     
     drawPoint(frame.getCoordsOfJoint(jointFocus));
     
     /*
     if(selector.isWithinRegion(frame.getCoordsOfJoint(controller.getJoint()))){
        window.stroke(220, 0, 0);
        
        if(highlightWhich == HighlightWhich.DIRECT) {
            drawPoint(frame.getCoordsOfJoint(jointFocus));
        } else { // HightlightWhich.CONTROLLER_LEAD
            drawPoint(frame.getCoordsOfConjoinedJoint(jointFocus));
        }
       
       
     }
     
     window.stroke(000);
     drawPoint(frame.getCoordsOfJoint(jointFocus));
     */
   }
   
   void drawPoint(float[] coords) {
       window.point(coords[0], coords[1], coords[2]);  
   }
   
   void drawPoint(float x, float y, float z){
       window.point(x, y, z);      
   }
   
   public void handleToggleDrawAmount(){
      shouldDrawAll = !shouldDrawAll;
   }
}

/*
class DrawEveryPoint extends DrawingStrategy {
  
   void drawDataPoint(Iterable<Joint> datapoint) {
      Iterator<Joint> dpIt = datapoint.iterator();
      
      while(dpIt.hasNext()){    
         float[] curJointCoords = dpIt.next().coordinates;
         drawBall(curJointCoords[0], curJointCoords[1], curJointCoords[2]);
      }
   }
   
   void drawBall(float x, float y, float z){
      pushMatrix();
      fill(255);
      translate(scale * x, -scale * y, scale * z);
      sphere(2);
      popMatrix();
   }
}

class PlainSpheres extends DrawingStrategy {
  
   void drawDataPoint(Iterable<Joint> datapoint) {
      Iterator<Joint> dpIt = datapoint.iterator();
      
      while(dpIt.hasNext()){  
         Joint curJoint = dpIt.next();
         if(curJoint.jointName.equals("lradius")){
           float[] curJointCoords = curJoint.coordinates;
           drawBall(curJointCoords[0], curJointCoords[1], curJointCoords[2]);
         }
      }
   }
   
   void drawBall(float x, float y, float z){
        pushMatrix();
        fill(255);
        translate(scale * x, scale * y, scale * z);
        sphere(1);
        popMatrix();
   }
}

class SimpleSpheres extends DrawingStrategy {
     void drawDataPoint(Iterable<Joint> datapoint) {
      sphereDetail(3);
      Iterator<Joint> dpIt = datapoint.iterator();
      
      while(dpIt.hasNext()){  
         Joint curJoint = dpIt.next();
         if(curJoint.jointName.equals("lradius")){
           float[] curJointCoords = curJoint.coordinates;
           drawBall(curJointCoords[0], curJointCoords[1], curJointCoords[2]);
         }
      }
   }
   
   void drawBall(float x, float y, float z){
      pushMatrix();
      fill(255);
      translate(scale * x, scale * y, scale * z);
      sphere(1);
      popMatrix();
   }
}
*/
