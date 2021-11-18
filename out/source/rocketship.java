import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class rocketship extends PApplet {

float fishAngle; 
float endX;
float endY;
float speed; 
float updatingX, updatingY;
float currentX = 0;
float currentY = 0;

float t = 0;

boolean swimming = false;

public void setup() {
  
  frameRate(30);

  // all of this is optional:
  colorMode(RGB, 1.0f);
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

public void draw() {

  float tmod;
  clear();
  background(0xff9DC1F5);

  // your code here

  if(swimming){
    fishAngle = atan2(endY-currentY,endX-currentX);
    tmod = (1 - cos(t * PI))/2; // ease-in-out
    updatingX = myLerp(tmod, currentX, endX);
    updatingY = myLerp(tmod, currentY, endY);
    
    translate(updatingX, updatingY);
    rotate(fishAngle);
    scale(0.20f);
    scale(-1,1); // I realized I wanted the fish to be drawn facing the other way
    drawRocketship();

    t = t + ((0.01f*value)/3) / dist(0, 0, endX, endY);
    if (t > 1) {
        swimming = false;
        currentX = updatingX;
        currentY = updatingY;
    }
  }
  else {
    translate(currentX, currentY);
    rotate(fishAngle);
    scale(0.20f);
    scale(-1,1); // I realized I wanted the fish to be drawn facing the other way
    drawRocketship();
  }
  // use this for a unit coordinate system:
  resetMatrix();
  scale(1,-1); 
  image(numberPanel, -1, 1-2.0f*PANEL_HEIGHT/height, 2.0f*PANEL_WIDTH/width, 2.0f*PANEL_HEIGHT/height);
  // use this for a window coordinate system:
  //image(controlPanel, 0, height-PANEL_HEIGHT, PANEL_WIDTH, PANEL_HEIGHT);
  
}

public void mousePressed() {

 
  if(!swimming){
    if (mouseY > height - PANEL_HEIGHT) {
      // click in control panel
      value = mouseX / (width / PANEL_ICONS);
      println("Changed value to:", value);
      swimming = false;
    } else { 
        t = 0;
        swimming = true;
        endX = 2.0f * mouseX / width - 1;
        endY = 2.0f * (height-mouseY+1) / height - 1;
      
    }
  }
}


public float myLerp(float t, float startKeyFrame, float endKeyFrame){
	return (1-t)*startKeyFrame+t*endKeyFrame; // where t = [0...1], we get positions [a,b]
}

public void drawRocketship(){

  beginShape(TRIANGLES);
    fill(0xffF5E584);
    // tail
    vertex(0.4f, 0);
    vertex(0.99f, 0.4f);
    vertex(0.99f, -0.4f);

    // fins
    vertex(-0.3f, 0.3f);
    vertex(0, 0.8f);
    vertex(0.1f, 0.5f);
    vertex(-0.3f, -0.3f);
    vertex(0, -0.8f);
    vertex(0.1f, -0.5f);
  endShape();

  fill(0xffB2A9F5);
  ellipse(-0.25f, 0, 1.5f, 0.84f);

  noStroke();
  fill(0xffF5E584);
  ellipse(-0.25f, 0, 1.2f, 0.04f);  // spine line

  noStroke();
  fill(0xff8391DE);
  ellipse(-0.7f, 0, 0.4f, 0.6f); // head

  fill(0xff3E0078);
  ellipse(-0.7f, 0.3f, 0.1f, 0.05f);  // eyes
  ellipse(-0.7f, -0.3f, 0.1f, 0.05f);
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
  public void settings() {  size(640, 640, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "rocketship" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
