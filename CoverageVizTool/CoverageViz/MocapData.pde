
class MocapData {
  int frameNum = 0;
  Frame[] frames;
  
  MocapData(String path) {
    JSONArray dataArray = loadJSONArray(path);
    frames = new Frame[dataArray.size()];
    
    for (int i = 0; i < dataArray.size(); i++) {
        JSONObject frameJSON = dataArray.getJSONObject(i);
        Frame fr = new Frame(frameJSON);
        frames[i] = fr;
    }
    
    adjustToProcessingCoordinates();
  }
    
  void adjustToProcessingCoordinates() {
    for (int f = 0; f < frames.length; f++){
      Iterator<Joint> jIter = frames[f].joints.iterator();
      while(jIter.hasNext()){
        Joint joint = jIter.next();
        joint.coordinates[0] = joint.coordinates[0];
        joint.coordinates[1] = -1 * joint.coordinates[1];
        joint.coordinates[2] = joint.coordinates[2];        
      }
    }
  }
  
  void display() {
     for(int i = 0; i < frames.length; i++){
       frames[i].display(); 
     }
  }
  
  Vector<Joint> aggregate(){
    Vector<Joint> allJoints = new Vector<Joint>(); 
    
    
    
    return allJoints;
  }
  
}

class Frame {
  // Represents an entire "body" of mocap joints
  Set<Joint> joints = new HashSet();
  
  Frame(JSONObject frameJSON) {
    Iterator<String> jointLabels = frameJSON.keyIterator();
    
    String curJointKey;
    JSONObject curJoint;
    // takes each joint in the frameJSON and adds it to the joints
    while (jointLabels.hasNext()) {
      curJointKey = jointLabels.next();
      curJoint = frameJSON.getJSONObject(curJointKey);
      
      Joint j = new Joint(curJointKey, curJoint);
      joints.add(j);
    }
  }
  
  void display(){
     drawer.drawDataPoint(joints);
  }
  
  
}

public class Joint {
  // Represents a single mocap joint
  //  displays as a ball
  String jointName;
  float[] coordinates = new float[3];
  
  Joint(String jointName, JSONObject jointJSON) {
    this.jointName = jointName;
    coordinates = jointJSON.getJSONArray("coordinate").getFloatArray();
  }
}
