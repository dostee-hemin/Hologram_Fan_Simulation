import processing.javafx.*;

// The static image we will be displaying on the fan
// PImage img;

LED[] leds = new LED[6];                          // Array of LEDs
int minDiameter = 350;                            // Diameter of the inner most circle
int maxDiameter = 660;                            // Diameter of the outer most circle
int visibleArea = (maxDiameter - minDiameter)/2;  // The area between the two circle boundaries
int LEDsize = visibleArea/leds.length;            // The size allocated for each LED in the visible area

double rpm = 5700;                  // Revolutions per minute
double totalMicroseconds;           // Time in microseconds since the program has started
double arcIncrement = 0.001;        // The prevision level of displaying the LEDs
double mspr = 1/(rpm/(60*100000));  // Microseconds per revolution
double rpf = (rpm/60)/60;           // Revolution per frame
double arcTraveled = rpf*TWO_PI;    // How much the fan rotates in one frame
double numberOfIncrements = (double) (ceil((float)arcTraveled/ (float)arcIncrement));             // How many times you need to move the LEDs before covering the entire arc of the frame
double microsecondIncrementPerFrame = 100000.0/60;                                                // Time in microseconds that will pass every frame
double microsecondIncrementPerArcIncrement = microsecondIncrementPerFrame / numberOfIncrements;   // Time in microseconds that will pass every small increment

void setup() {
  size(800, 800, FX2D);

  setupAnimation();

  // Load the image and initialize the LEDs
  // img = loadImage("hello.png");
  for(int i=0; i<leds.length; i++) {
    leds[i] = new LED();
  }
}

void draw() {
  background(255);
  // Draw the image to the center of the canvas
  // imageMode(CENTER);
  // image(img, width/2, height/2, width, height);
  playAnimation();

  // Draw the boundaries of the fan
  stroke(255, 0, 0);
  strokeWeight(1);
  noFill();
  ellipse(width/2, height/2, maxDiameter, maxDiameter);
  ellipse(width/2, height/2, minDiameter, minDiameter);

  PVector center = new PVector(width/2, height/2);
  loadPixels();
  noStroke();

  // Starting angle of the fan (starts at the top)
  float angle = -HALF_PI;
  totalMicroseconds = 0;

  for(LED l : leds) l.resetFrame();

  // While we haven't yet completed the required number of revolutions, keep updating and displaying the fan
  while(totalMicroseconds < ceil((float)rpf) * mspr) {
    for (int i=0; i<leds.length; i++) {
      LED led = leds[i];

      // Get the position of the current LED on the canvas
      float magnitude = minDiameter/2 + (LEDsize * (i+0.5));
      if(i % 2 == 0) magnitude *= -1;
      PVector p = PVector.fromAngle(angle).mult(magnitude);
      p.add(center);

      // Get the average color of the pixels around the LED's position
      float currentBrightness = 0;
      for(int j=-5; j<=5; j++) {
        for(int k=-5; k<=5; k++) {
          int index = int(p.x + j) + int(p.y + k) * width;
          color c = pixels[index];

          currentBrightness += brightness(c);
        }
      }
      currentBrightness /= 5*5;

      // Represents if the LED should be on at this position or not (based on brightness)
      boolean isOn = currentBrightness < 80;

      if(led.actions.isEmpty()) led.setInitialState(isOn);

      if(led.hasChangedState(isOn)) led.recordState();

      // Display for visualization purposes
      fill(0, 255, 0, isOn ? 50 : 0);
      ellipse(p.x, p.y, LEDsize*0.6, LEDsize*0.6);
    }
    
    // Keep track of the total time that has elapsed and the angle we have rotated
    totalMicroseconds += microsecondIncrementPerArcIncrement;
    angle += arcIncrement;
  }
  
  // Add the remaining state durations
  for(LED led : leds) {
    led.actions.add(new Action(ceil((float)rpf) * mspr-led.currentMicro,led.currentState));
  }
}

void keyPressed() {
  // Generate the output file
  String[] txt = new String[leds.length];
  for(int i=0; i<leds.length; i++) {
    LED led = leds[i];

    String line = "";

    // Each state value + it's duration
    boolean previousState = led.actions.get(0).state;
    double totalDuration = led.actions.get(0).duration;
    for(int j=1; j<led.actions.size(); j++) {
      Action a = led.actions.get(j);

      if(previousState == a.state) {
        totalDuration += a.duration;
        continue;
      }

      line += (previousState?"1":"0") + "," + totalDuration + ";";
      previousState = a.state;
      totalDuration = a.duration;
    }
    line += (previousState?"1":"0") + "," + totalDuration;
    txt[i] = line;
  }

  saveStrings("output.txt", txt);
  println("Animation saved!");
}
