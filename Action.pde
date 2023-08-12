class Action {
  double duration;    // Duration of the action
  boolean state;      // false = LED off, true = LED on
  
  Action(double duration, boolean state) {
    this.duration = duration;
    this.state = state;
  }
}
