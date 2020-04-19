

public enum Events {
  Q_PRESS,
  Z_PRESS,
  W_PRESS,
  A_PRESS,
  S_PRESS,
  D_PRESS,
  X_PRESS,
  F_PRESS,
  SHIFT_PRESS,
  CTRL_PRESS,
  SPACE_PRESS
};

public class EventManager {
 
  private Map<Events, List<Runnable>> eventSubscriptionRegistry;
  
  public EventManager(){
    eventSubscriptionRegistry = new HashMap<Events, List<Runnable>>();
    
    for(Events ev: Events.values()){
      eventSubscriptionRegistry.put(ev, new Vector<Runnable>());  
    }
  }
  
  public void addListener(Events event, Runnable response){
    eventSubscriptionRegistry.get(event).add(response); 
  }
  
  public void trigger(Events event){
     println(event);
     for(Runnable func: eventSubscriptionRegistry.get(event)){
       try {
         func.run();
       } catch (Exception e) {
         println(e.toString());
       }
     }
  }
    
  
}
