class LED {
  ArrayList<Action> actions = new ArrayList<Action>();
  boolean startState;
  boolean currentState;
  double currentMicro;

  boolean hasChangedState(boolean isOn) {
    return isOn != currentState;
  }

  void resetFrame() {
    currentMicro = 0;
  }

  void recordState() {
    actions.add(new Action(totalMicroseconds-currentMicro, currentState));
    currentState = !currentState;
    currentMicro = totalMicroseconds;
  }

  void setInitialState(boolean state) {
    startState = state;
    currentState = state;
  }
}
