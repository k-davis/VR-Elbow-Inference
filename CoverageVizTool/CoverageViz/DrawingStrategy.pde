

abstract class DrawingStrategy {
   abstract void drawDataPoint(Iterable<Joint> datapoint); 
}

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

class Points extends DrawingStrategy {
     void drawDataPoint(Iterable<Joint> datapoint) {
      stroke(000);
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
      point(scale*x, scale*y, scale*z);
      
   }
}
