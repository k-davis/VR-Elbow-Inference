
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
        joint.getValue()[0] = scale * joint.getValue()[0];
        joint.getValue()[1] = -1 * scale * joint.getValue()[1];
        joint.getValue()[2] = scale * joint.getValue()[2];
      }
    }
  }  
  
  public Iterator<Frame> iterator() {
    Iterator<Frame> frIt = frames.iterator();
    if(frIt == null)
      println("Iterator resolves as null");
    return frIt;
  }
    
}

public class Frame {
  // Represents an entire "body" of mocap joints
  //  limited here to two joints
  private Map<String, float[]> joints = new HashMap();
  
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
  
  public float[] getCoordsOfJoint(String jointLabel){
    return joints.get(jointLabel);
  }
  
  public float[] getCoordsOfConjoinedJoint(String origJoint){
    for(String j : joints.keySet()){
      if(! j.equals(origJoint)){
        return getCoordsOfJoint(j);
      }
    }
    return null;
  }
  
}
