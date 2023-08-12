class LED {
  ArrayList<Double> times = new ArrayList<Double>();
  boolean startState;
  boolean currentState;
  double currentMicro;

  boolean hasChangedState(boolean isOn) {
    return isOn != currentState;
  }

  void recordState() {
    currentState = !currentState;
    times.add(totalMicroseconds-currentMicro);
    currentMicro = totalMicroseconds;
  }

  void setInitialState(boolean state) {
    startState = state;
    currentState = state;
  }
}
