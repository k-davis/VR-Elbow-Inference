

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
    perspective(fov, float(width)/float(height), 
            cameraZ/100.0, cameraZ*10.0);
           
    drawer = new DrawPoints(parent);
  }
  
  public void draw() {
    drawer.drawUtilityObjects();  
    if(dataController != null)
      drawer.drawPoints(dataController);
  }
  
  public void handleToggleDrawAmount() {
    drawer.handleToggleDrawAmount(); 
  }
}
