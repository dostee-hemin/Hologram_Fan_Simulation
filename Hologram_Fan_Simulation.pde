import processing.javafx.*;

LED[] leds = new LED[6];                          // Array of LEDs
int minDiameter = 350;                            // Diameter of the inner most circle
int maxDiameter = 660;                            // Diameter of the outer most circle
int visibleArea = (maxDiameter - minDiameter)/2;  // The area between the two circle boundaries
int LEDsize = visibleArea/leds.length;            // The size allocated for each LED in the visible area

double angle = -HALF_PI;            // Current angle of the fan
double rpm = 5700;                  // Revolutions per minute
double totalMicroseconds;           // Time in microseconds since the program has started
double arcIncrement = 0.001;        // The prevision level of displaying the LEDs

void setup() {
  size(800, 800, FX2D);


  String[] txt = loadStrings("input.txt");
  for (int i = 0; i < txt.length; i++) {
    float distance = minDiameter/2 + (LEDsize * (i+0.5)); // Distances: 60, 90, 120, ...
    if(i % 2 == 0) distance *= -1;
    

    String line = txt[i];
    String[] allActions = line.split(";");
    ArrayList<Action> actions = new ArrayList<Action>();
    for(int j=0; j<allActions.length; j++) {
      String[] numbers = allActions[j].split(",");
      actions.add(new Action(Double.parseDouble(numbers[1]),numbers[0].equals("1")));
    }
    leds[i] = new LED(distance, actions.toArray(new Action[actions.size()]));
  }
}

void draw() {
  background(0);
  
  // Control the fan speed using the mouse's x-position
  // rpm = map(mouseX,0,width,0,5700);
  // if(rpm > 5680) rpm = 5700;

  double mspr = 1/(rpm/(60*100000));  // Microseconds per revolution
  double rpf = (rpm/60)/60;           // Revolution per frame
  double arcTraveled = rpf*TWO_PI;    // How much the fan rotates in one frame
  double numberOfIncrements = (double) (ceil((float)arcTraveled/ (float)arcIncrement));             // How many times you need to move the LEDs before covering the entire arc of the frame
  double microsecondIncrementPerFrame = 100000.0/60;                                                // Time in microseconds that will pass every frame
  double microsecondIncrementPerArcIncrement = microsecondIncrementPerFrame / numberOfIncrements;   // Time in microseconds that will pass every small increment


  // Move to the center of the canvas rotate to the current angle
  pushMatrix();
  translate(width / 2, height / 2);
  rotate((float)angle);
  noStroke();

  for (int i = 0; i < numberOfIncrements; i++) {
    // Rotate slightly based on the set level of precision
    rotate((float)arcIncrement);

    // Loop through each LED in the rod
    for (LED led : leds) {
      // If the current action of the led has been completed, move onto the next action and set the new state
      if (led.currentActionIsFinished()) led.moveToNextAction();

      // Display the LED based on if it's on or off
      led.display();
    }

    // Keep track of the total time that has elapsed 
    totalMicroseconds += microsecondIncrementPerArcIncrement;
  }
  popMatrix();

  // Move the starting angle as much as the fan rotates in a single frame
  angle += arcTraveled;
}
