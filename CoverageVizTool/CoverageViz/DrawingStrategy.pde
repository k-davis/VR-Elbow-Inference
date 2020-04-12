

abstract class DrawingStrategy { 
   protected boolean shouldDrawAll = false;
   abstract void drawPoints(MocapData data);
   protected PApplet window;
   
   public DrawingStrategy(PApplet window){
     this.window = window;
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

class DrawPoints extends DrawingStrategy {
   private float percentageToDraw = 0.2;
   private String jointFocus = JOINT_A;
   
   public DrawPoints(PApplet window){
     super(window); 
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
     window.stroke(000);
     
     float[] curJointCoords = frame.joints.get(jointFocus);
     drawPoint(curJointCoords[0], curJointCoords[1], curJointCoords[2]);
   }
   
   
   void drawPoint(float x, float y, float z){
       window.point(scale*x, scale*y, scale*z);      
   }
   
   public void handleToggleDrawAmount(){
      shouldDrawAll = !shouldDrawAll;
   }
}
