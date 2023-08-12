class LED {
  boolean currentState; // 0 for off, 1 for on
  double distanceFromCenter; // Distance from the center of the screen
  double currentMicro;
  ArrayList<Action> actions = new ArrayList<Action>();
  int currentIndex;

  LED(double distance, ArrayList<Action> actions) {
    this.distanceFromCenter = distance;
    this.currentMicro = 0;
    this.actions = actions;
    currentState = actions.get(0).state;
    currentIndex = 0;
  }
}
