void setup() {
  size(640, 640, P3D);
  frameRate(30);

  // all of this is optional:
  colorMode(RGB, 1.0);
  ortho(-1, 1, 1, -1);
  resetMatrix();
  hint(DISABLE_OPTIMIZED_STROKE);
  
  // this is required:
  numberPanel = loadImage("NumberPanel.png");
  if (numberPanel == null) {
    println("Can't find NumberPanel.png - did you put it in the sketch folder?");
    System.exit(0);
  }
}

void draw() {
  background(0, 0, 0);

  // your code here
  
  // use this for a unit coordinate system:
  resetMatrix();
  scale(1,-1);
  image(numberPanel, -1, 1-2.0*PANEL_HEIGHT/height, 2.0*PANEL_WIDTH/width, 2.0*PANEL_HEIGHT/height);
  // use this for a window coordinate system:
  //image(controlPanel, 0, height-PANEL_HEIGHT, PANEL_WIDTH, PANEL_HEIGHT);
}

void mousePressed() {
  if (mouseY > height - PANEL_HEIGHT) {
    // click in control panel
    value = mouseX / (width / PANEL_ICONS);
    println("Changed value to:", value);
  } else {
    // your code here...
  }
}

int value = 4;
PImage numberPanel;
int PANEL_ICONS = 10;
int PANEL_WIDTH = 640; 
int PANEL_HEIGHT = 64;
