class LED {
  boolean currentState;      // 0 for off, 1 for on
  double distanceFromCenter; // Distance from the center of the screen
  double currentMicro;       // A timer in microseconds used to determine how much time has elapsed since the last action
  int currentIndex;          // The current action we are executing
  Action[] actions;          // A list of actions this LED will perform on and off states + their durations

  LED(double distance, Action[] actions) {
    this.distanceFromCenter = distance;
    this.actions = actions;
    currentState = actions[0].state;
    currentMicro = 0;
    currentIndex = 0;
  }

  boolean currentActionIsFinished() {
    // Return true if enough time has elapsed for the current action to be completed
    return totalMicroseconds - currentMicro >= actions[currentIndex].duration;
  }

  void moveToNextAction() {
    // Update the microsecond counter
    currentMicro += actions[currentIndex].duration;

    // Move onto the next action (loop back to the start if we've reached the end)
    currentIndex++;
    currentIndex %= actions.length;

    // Set the current state based on the new action
    currentState = actions[currentIndex].state;
  }

  void display() {
    if(currentState) fill(0,255,0,10);
    else noFill();
    ellipse((float)distanceFromCenter, 0, LEDsize*0.6, LEDsize*0.6);
  }
}
