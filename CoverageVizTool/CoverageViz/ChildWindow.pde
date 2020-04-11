class ChildApplet extends PApplet {
 
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  
  public void settings() {
    size(400, 400, P3D);
    smooth();
  }
  
  public void setup() {    surface.setTitle("Viewer");
  
  
  }
 
  public void draw(){
    background(255);
  }
  
}
