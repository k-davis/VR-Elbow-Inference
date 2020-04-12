

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
    perspective(fov, float(width)/float(height), 
            cameraZ/100.0, cameraZ*10.0);
           
    viewDrawer = new DrawPoints(parent);
  }
  
  public void draw() {
    viewDrawer.drawUtilityObjects();
    if(dataController != null)
      viewDrawer.drawPoints(dataController);
  }
  
  public void handleToggleDrawAmount() {
    viewDrawer.handleToggleDrawAmount(); 
  }
}
