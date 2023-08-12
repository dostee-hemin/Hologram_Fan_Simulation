PImage img;

int minDiameter = 350;
int maxDiameter = 660;
int visibleArea = (maxDiameter - minDiameter)/2;
LED[] leds = new LED[7];
int LEDsize = visibleArea/leds.length;

double rpm = 5700;
double totalMicro;
double arcIncrement = 0.001;
double mspr = 1/(rpm/(60*100000));
double rpf = (rpm/60)/60;
double arcTraveled = rpf*TWO_PI;
final double numberOfIncrements = (double) (ceil((float)arcTraveled/ (float)arcIncrement));
final double microsecondIncrementPerFrame = 100000.0/60;
final double microsecondIncrementPerArcIncrement = microsecondIncrementPerFrame / numberOfIncrements;

void setup() {
  size(800, 800);

  img = loadImage("hello.png");
  for(int i=0; i<leds.length; i++) {
    leds[i] = new LED();
  }
}

void draw() {
  imageMode(CENTER);
  image(img, width/2, height/2, width, height);

  stroke(255, 0, 0);
  strokeWeight(1);
  noFill();
  ellipse(width/2, height/2, maxDiameter, maxDiameter);
  ellipse(width/2, height/2, minDiameter, minDiameter);

  PVector center = new PVector(width/2, height/2);
  loadPixels();
  background(0);
  noStroke();
  float angle = -HALF_PI;
  while(totalMicro < ceil((float)rpf) * mspr) {
    for (int i=0; i<leds.length; i++) {
      LED led = leds[i];
      float magnitude = minDiameter/2 + (LEDsize * (i+0.5));
      PVector p = PVector.fromAngle(angle).mult(magnitude);
      p.add(center);

      int index = int(p.x) + int(p.y) * width;
      color c = pixels[index];
      boolean isOn = red(c) < 10;
      if(totalMicro == 0) {
        led.startStateOn = isOn;
        led.currentState = isOn;
      }
      
      if(isOn != led.currentState) {
        led.currentState = !led.currentState;
        led.onOffTimes.add(totalMicro-led.currentMicro);
        led.currentMicro = totalMicro;
      }
      fill(0, 255, 0, (red(c) < 10) ? 50 : 0);
      ellipse(p.x, p.y, LEDsize*0.6, LEDsize*0.6);
    }
    
    totalMicro += microsecondIncrementPerArcIncrement;
    angle += arcIncrement;
  }
  
  for(LED led : leds) {
    led.onOffTimes.add(ceil((float)rpf) * mspr-led.currentMicro);
  }
  
  ArrayList<String> txt = new ArrayList<String>();
  txt.add(leds.length + "");
  for(int i=0; i<leds.length; i++) {
    LED led = leds[i];
    boolean tempState = led.startStateOn;
    txt.add(led.onOffTimes.size() + "");
    for(Double d:led.onOffTimes) {
      txt.add((tempState?"1":"0") + "," + d);
      tempState = !tempState;
    }
  }
  String[] output = new String[txt.size()];
  for(int i=0; i<output.length; i++) {
    output[i] = txt.get(i);
  }
  saveStrings("output.txt", output);
  
  noLoop();
}
