

abstract class DrawingStrategy {
   abstract void drawPoints(MocapData data);
  // abstract void drawDataPoint(Iterable<Joint> datapoint); 
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

class Points extends DrawingStrategy {
   private boolean shouldDrawAll = false;
   private float percentageToDraw = 0.2;
   private String jointFocus = JOINT_A;
   
   public void drawPoints(MocapData data){
     int countToIgnore = (int) (1 / percentageToDraw);
     int countCycler = 0;
     
     Iterator<Frame> frameIt = data.iterator();
     
     while(frameIt.hasNext()) {
       Frame curFrame = frameIt.next();
       
       if(shouldDrawAll) {
         if(countCycler % countToIgnore == 0) {
           drawDataPoint(curFrame);
         }
  
         countCycler++;
       } else {
          drawDataPoint(curFrame); 
       }
     }
   }
   
   void drawDataPoint(Frame frame) {    
     stroke(000);
     
     float[] curJointCoords = frame.joints.get(jointFocus);
     drawBall(curJointCoords[0], curJointCoords[1], curJointCoords[2]);
   }
   
   
   void drawBall(float x, float y, float z){
       point(scale*x, scale*y, scale*z);      
   }
   
   public void handleToggleDrawAmount(){
      shouldDrawAll = !shouldDrawAll;
   }
}
