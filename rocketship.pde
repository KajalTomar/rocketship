float fishAngle; 
float endX;
float endY;
float speed; 
float updatingX, updatingY;
float currentX = 0;
float currentY = 0;

float t = 0;

boolean swimming = false;

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

  float tmod;
  clear();
  background(#9DC1F5);

  // your code here

  if(swimming){
    fishAngle = atan2(endY-currentY,endX-currentX);
    tmod = (1 - cos(t * PI))/2; // ease-in-out
    updatingX = myLerp(tmod, currentX, endX);
    updatingY = myLerp(tmod, currentY, endY);
    
    translate(updatingX, updatingY);
    rotate(fishAngle);
    scale(0.20);
    scale(-1,1); // I realized I wanted the fish to be drawn facing the other way
    drawRocketship();

    t = t + ((0.01*value)/3) / dist(0, 0, endX, endY);
    if (t > 1) {
        swimming = false;
        currentX = updatingX;
        currentY = updatingY;
    }
  }
  else {
    translate(currentX, currentY);
    rotate(fishAngle);
    scale(0.20);
    scale(-1,1); // I realized I wanted the fish to be drawn facing the other way
    drawRocketship();
  }
  // use this for a unit coordinate system:
  resetMatrix();
  scale(1,-1); 
  image(numberPanel, -1, 1-2.0*PANEL_HEIGHT/height, 2.0*PANEL_WIDTH/width, 2.0*PANEL_HEIGHT/height);
  // use this for a window coordinate system:
  //image(controlPanel, 0, height-PANEL_HEIGHT, PANEL_WIDTH, PANEL_HEIGHT);
  
}

void mousePressed() {

 
  if(!swimming){
    if (mouseY > height - PANEL_HEIGHT) {
      // click in control panel
      value = mouseX / (width / PANEL_ICONS);
      println("Changed value to:", value);
      swimming = false;
    } else { 
        t = 0;
        swimming = true;
        endX = 2.0 * mouseX / width - 1;
        endY = 2.0 * (height-mouseY+1) / height - 1;
      
    }
  }
}


float myLerp(float t, float startKeyFrame, float endKeyFrame){
	return (1-t)*startKeyFrame+t*endKeyFrame; // where t = [0...1], we get positions [a,b]
}

void drawRocketship(){

  beginShape(TRIANGLES);
    fill(#F5E584);
    // tail
    vertex(0.4, 0);
    vertex(0.99, 0.4);
    vertex(0.99, -0.4);

    // fins
    vertex(-0.3, 0.3);
    vertex(0, 0.8);
    vertex(0.1, 0.5);
    vertex(-0.3, -0.3);
    vertex(0, -0.8);
    vertex(0.1, -0.5);
  endShape();

  fill(#B2A9F5);
  ellipse(-0.25, 0, 1.5, 0.84);

  noStroke();
  fill(#F5E584);
  ellipse(-0.25, 0, 1.2, 0.04);  // spine line

  noStroke();
  fill(#8391DE);
  ellipse(-0.7, 0, 0.4, 0.6); // head

  fill(#3E0078);
  ellipse(-0.7, 0.3, 0.1, 0.05);  // eyes
  ellipse(-0.7, -0.3, 0.1, 0.05);
}

// final float[][] ROCKET_VERTICES = new float[][] {
//   {0,0.25}, // top of hat rim
//   {-0.25, 0}, // left of hat rim
//   {0.25, 0} // right of hat rim
// }

// rocketship vertices 

int value = 4;
PImage numberPanel;
int PANEL_ICONS = 10;
int PANEL_WIDTH = 640; 
int PANEL_HEIGHT = 64;

// color pallete:
// #B2A9F5  main fish color purple
// #F5CFB5  peach
// #9DC1F5  water
// #F5E584  yellow
// #90EFF5  aqua