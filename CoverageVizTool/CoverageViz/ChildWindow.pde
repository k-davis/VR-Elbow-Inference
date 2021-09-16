class ChildApplet extends PApplet {
 // UtilityDrawer utilDrawer;
  private Viewer viewer;
  
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  
  public void settings() {
    size(800, 800, P3D);
    noSmooth();
  }
  
  public void setup() {
    surface.setTitle("Viewer");
    viewer = new Viewer(this);
    viewer.setup();
  }
 
  public void draw(){
    background(255);
    translate(-scale/2, scale/2, -scale/2);
    viewer.draw();
  }  
  
  void keyPressed(){
    if(key == ' '){
      eventManager.trigger(Events.SPACE_PRESS);
    }
  }
}
