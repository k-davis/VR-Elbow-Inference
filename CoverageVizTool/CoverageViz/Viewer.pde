public class Viewer {
  PeasyCam cam;
  DrawingStrategy viewDrawer;
  PApplet parent;
  
  public Viewer(PApplet parent) {
    this.parent = parent;
  }
  
  public void setup() {
    cam = new PeasyCam(parent, 100);
    cam.setMinimumDistance(25);
    cam.setMaximumDistance(500);
    cam.setSuppressRollRotationMode();
    
    float fov = PI/3.0;
    float cameraZ = (height/2.0) / tan(fov/2.0);
    parent.perspective(fov, float(width)/float(height), 
            cameraZ/1000.0, cameraZ*10.0);
           
    viewDrawer = new DrawPoints(parent, JOINT_B, HighlightWhich.CONTROLLER_LEAD);
    eventManager.addListener(Events.SPACE_PRESS, new Runnable() {public void run(){handleToggleDrawAmount();}});
  }
  
  public void draw() {
    viewDrawer.drawUtilityObjects();
    if(dataHolder != null)
      viewDrawer.drawPoints(dataHolder);
  }
  
  public void handleToggleDrawAmount() {
    viewDrawer.handleToggleDrawAmount(); 
  }
}
