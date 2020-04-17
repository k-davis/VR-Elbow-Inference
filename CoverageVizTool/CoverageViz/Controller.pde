public class Controller {
  PeasyCam cam;
  DrawingStrategy drawer;
  PApplet parent;
  
  public Controller(PApplet parent){
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
           
    drawer = new DrawPoints(parent, JOINT_A, HighlightWhich.DIRECT);
    
    selector = new SphereRegion(25, -25, 25, 5);
    
    eventManager.addListener(Events.SPACE_PRESS, new Runnable() {public void run(){handleToggleDrawAmount();}});
  }
  
  public void draw() {
    drawer.drawUtilityObjects();  
    
    if(dataHolder != null)
      drawer.drawPoints(dataHolder);
      
    selector.draw(parent);
  }
  
  public void handleToggleDrawAmount() {
    drawer.handleToggleDrawAmount(); 
  }
  
  public String getJoint(){
    return JOINT_A; 
  }
}
