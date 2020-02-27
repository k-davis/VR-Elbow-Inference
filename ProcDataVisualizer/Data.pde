
class PostProcData {
  int frameNum = 0;
  Frame[] frames;
  
  PostProcData(String path) {
    JSONArray dataArray = loadJSONArray(path);
    frames = new Frame[dataArray.size()];
    
    for (int i = 0; i < dataArray.size(); i++) {
        JSONObject frameJSON = dataArray.getJSONObject(i);
        Frame fr = new Frame(frameJSON);
        frames[i] = fr;
    }
    
    adjustToProcessingCoordinates();
  }
  
  void update(){
    fill(0, 0, 200);
    frames[frameNum].display(); 
    frameNum = (frameNum + 1) % frames.length;
  }
  
  void adjustToProcessingCoordinates(){
    for (int f = 0; f < frames.length; f++){
      Iterator<Joint> jIter = frames[f].joints.iterator();
      while(jIter.hasNext()){
        Joint joint = jIter.next();
        joint.coordinates[0] =      50 * joint.coordinates[0];
        joint.coordinates[1] = -1 * 50 * joint.coordinates[1];
        joint.coordinates[2] =      50 * joint.coordinates[2];        
      }
    }
  }
}

class PreProcData {
  int frameNum = 0;
  Frame[] frames;
  
  // PreProcData is stored as a JSONObject at the highest level
  PreProcData(String path) {
    JSONObject dataObject = loadJSONObject(path);
    frames = new Frame[dataObject.size()];
    
    for (int i = 0; i < dataObject.size(); i++) {
      String dataKey = "" + (i);
      JSONObject frameJSON = dataObject.getJSONObject(dataKey);
      
      Frame fr = new Frame(frameJSON);
      frames[i] = fr;
    }
    
    adjustToProcessingCoordinates();
  }

  // draws the data with the given color
  //  will wrap around and repeat
  void update(){
    fill(200, 0, 0);
    frames[frameNum].display(); 
    frameNum = (frameNum + 1) % frames.length;
  }
  
  // it just takes all the coordinates and inverts the Y-axis
  void adjustToProcessingCoordinates(){
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
    Iterator<Joint> jointIter = joints.iterator();
    while(jointIter.hasNext()){
      jointIter.next().display();
    }
  }
  
  
}

class Joint {
  // Represents a single mocap joint
  //  displays as a ball
  String jointName;
  float[] coordinates = new float[3];
  
  Joint(String jointName, JSONObject jointJSON) {
    this.jointName = jointName;
    coordinates = jointJSON.getJSONArray("coordinate").getFloatArray();
  }
  
  void display(){
    drawBall(coordinates);
  }
}
