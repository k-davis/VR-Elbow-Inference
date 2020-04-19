
public class SphereRegion {
   private int[] coords;
   private float radius;
   
   public SphereRegion(int x, int y, int z, int radius){
     coords = new int[] {x, y, z};
     this.radius = radius;
     
     
     eventManager.addListener(Events.W_PRESS, new Runnable()     {public void run(){shiftLocation( 0,  0, -1);}});
     eventManager.addListener(Events.S_PRESS, new Runnable()     {public void run(){shiftLocation( 0,  0,  1);}});
     eventManager.addListener(Events.A_PRESS, new Runnable()     {public void run(){shiftLocation(-1,  0,  0);}});
     eventManager.addListener(Events.D_PRESS, new Runnable()     {public void run(){shiftLocation( 1,  0,  0);}});
     eventManager.addListener(Events.SHIFT_PRESS, new Runnable() {public void run(){shiftLocation( 0, -1,  0);}});
     eventManager.addListener(Events.CTRL_PRESS, new Runnable()  {public void run(){shiftLocation( 0,  1,  0);}});
     eventManager.addListener(Events.Q_PRESS, new Runnable()     {public void run(){shiftRadius( 0.5);}});
     eventManager.addListener(Events.Z_PRESS, new Runnable()     {public void run(){shiftRadius(-0.5);}});
   }
   
   public boolean isWithinRegion(float[] coords){
     double dist = Math.sqrt(Math.pow(this.coords[0] - coords[0], 2) + Math.pow(this.coords[1] - coords[1], 2) + Math.pow(this.coords[2] - coords[2], 2));
     //println(dist);
     return dist < radius;
   }
   
   public boolean doNothing(float[] c){
     return false;
   }
   
   public void shiftLocation(int dx, int dy, int dz){
     coords[0] += dx;
     coords[1] += dy;
     coords[2] += dz;
   }
   
   public void shiftRadius(float dr){
     radius += dr;
   }
   
   public void draw(PApplet window){
     window.stroke(50, 50, 50);
     window.lights();
     window.pushMatrix();
     window.fill(240, 70, 0, 70);
     window.translate(coords[0], coords[1], coords[2]);
       
     window.sphereDetail(8);
     window.sphere(radius);
     window.popMatrix();
   }
   
   public void drawTranslucent(PApplet window) {
     window.stroke(50, 50, 50, 70);
     window.lights();
     window.pushMatrix();
     window.fill(50, 70, 240, 50);
     window.translate(coords[0], coords[1], coords[2]);
       
     window.sphereDetail(8);
     window.sphere(radius);
     window.popMatrix();
   }
}
