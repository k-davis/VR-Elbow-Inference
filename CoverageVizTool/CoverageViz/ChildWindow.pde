class ChildApplet extends PApplet {
 // UtilityDrawer utilDrawer;
  private Viewer viewer;
  
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  
  public void settings() {
    size(400, 400, P3D);
    smooth();
  }
  
  public void setup() {
    surface.setTitle("Viewer");
    viewer = new Viewer(this);
    viewer.setup();
  }
 
  public void draw(){
    background(255);
    viewer.draw();
  }  
  
  void keyPressed(){
    if(key == ' '){
      viewer.handleToggleDrawAmount(); 
    }
  }
}
