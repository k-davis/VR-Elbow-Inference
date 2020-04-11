
class MocapData {
  int frameNum = 0;
  List<Frame> frames;
  
  MocapData(String path) {
    JSONArray dataArray = loadJSONArray(path);
    frames = new Vector<Frame>();
    
    for (int i = 0; i < dataArray.size(); i++) {
        JSONObject frameJSON = dataArray.getJSONObject(i);
        Frame fr = new Frame(frameJSON);
        frames.add(fr);
    }
    
    adjustToProcessingCoordinates();
  }
    
  void adjustToProcessingCoordinates() {
    Iterator<Frame> frameIt = iterator();
    
    while(frameIt.hasNext()){
      Frame curFrame = frameIt.next();
      Iterator<Map.Entry<String, float[]>> jIter = curFrame.joints.entrySet().iterator();
      
      while(jIter.hasNext()){
        Map.Entry<String, float[]> joint = jIter.next();
        joint.getValue()[1] = -1 * joint.getValue()[1];
      }
    }
  }  
  
  public Iterator<Frame> iterator() {
    return frames.iterator();
  }
    
}

class Frame {
  // Represents an entire "body" of mocap joints
  Map<String, float[]> joints = new HashMap();
  
  Frame(JSONObject frameJSON) {
    Iterator<String> jointLabels = frameJSON.keyIterator();
    
    String curJointKey;
    JSONObject curJoint;
    // takes each joint in the frameJSON and adds it to the joints
    while (jointLabels.hasNext()) {
      curJointKey = jointLabels.next();
      if(curJointKey.equals(JOINT_A) || curJointKey.equals(JOINT_B)){
        curJoint = frameJSON.getJSONObject(curJointKey);

        joints.put(curJointKey, curJoint.getJSONArray("coordinate").getFloatArray());
      }
    }
  }  
}
