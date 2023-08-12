import processing.javafx.*;

LED[] leds = new LED[7]; // Array of LEDs
double angle;
double rpm = 5700;
double totalMicro;
double onDelay = 20;
double arcIncrement = 0.001;

int minDiameter = 350;
int maxDiameter = 660;
int visibleArea = (maxDiameter - minDiameter)/2;
int LEDsize = visibleArea/leds.length;

void setup() {
  size(800, 800, FX2D);
  String[] txt = loadStrings("input.txt");
  int I = 0;
  int numLEDs = int(txt[I++]);
  for (int i = 0; i < numLEDs; i++) {
    float distance = minDiameter/2 + (LEDsize * (i+0.5)); // Distances: 60, 90, 120, ...
    
    int numActions = int(txt[I++]);
    ArrayList<Action> actions = new ArrayList<Action>();
    for(int j=0; j<numActions; j++) {
      String[] numbers = txt[I++].split(",");
      actions.add(new Action(Double.parseDouble(numbers[1]),numbers[0].equals("1")));
    }
    leds[i] = new LED(distance, actions);
  }
}

void draw() {
  background(0);
  
  // rpm = map(mouseX,0,width,0,5700);
  // if(rpm > 5600) rpm = 5700;

  double mspr = 1/(rpm/(60*100000));
  double rpf = (rpm/60)/60;
  double arcTraveled = rpf*TWO_PI;
  final double numberOfIncrements = (double) (ceil((float)arcTraveled/ (float)arcIncrement));
  final double microsecondIncrementPerFrame = 100000.0/60;
  final double microsecondIncrementPerArcIncrement = microsecondIncrementPerFrame / numberOfIncrements;


  pushMatrix();
  translate(width / 2, height / 2);
  rotate((float)angle-HALF_PI);
  noStroke();
  double tempMicro = totalMicro;
  for (int i = 0; i < numberOfIncrements; i++) {
    rotate((float)arcIncrement);
    for (LED led : leds) {
      Action a = led.actions.get(led.currentIndex);
      if (tempMicro - led.currentMicro >= a.duration) {
        led.currentMicro += a.duration;
        led.currentIndex++;
        led.currentIndex %= led.actions.size();
        led.currentState = led.actions.get(led.currentIndex).state;
      }
      if(led.currentState) fill(0,255,0,10);
      else noFill();
      ellipse((float)led.distanceFromCenter, 0, 30, 30);
    }
    tempMicro += microsecondIncrementPerArcIncrement;
  }
  popMatrix();
  totalMicro += microsecondIncrementPerFrame;

  angle += arcTraveled;
}
