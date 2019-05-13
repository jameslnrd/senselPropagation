/*
Model: Dynamic Topology Modifications.
Author: James Leonard (james.leonard@gipsa-lab.fr)

Draw a 2D Mesh of Osc modules (mass-spring-ground systems).

Left-Click Drag across the surface to apply forces and create ripples.
Right-Click Drag across the surface to remove masses (and connected links).

Use UP and DOWN keys to add/decrease air friction in the model.
Use LEFT and RIGHT keys to zoom the Z axis.
*/
import miPhysics.*;
import peasy.*;
PeasyCam cam;

int displayRate = 60;
int dimX = 115;
int dimY = 65;

PhysicalModel mdl;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int mouseDragged = 0;

int gridSpacing = 2;
int xOffset= 0;
int yOffset= 0;

float fric = 0.001;

// SETUP: THIS IS WHERE WE SETUP AND INITIALISE OUR MODEL

void setup() {
  fullScreen(P3D);
  //size(1150, 650, P3D);
  background(0);

  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(1500);

  mdl = new PhysicalModel(550, displayRate);
  mdl.setGravity(0.000);
  mdl.setFriction(fric);
  
  gridSpacing = 10; // (int)((height/dimX)*2);
  generatePinScreen(mdl, dimX, dimY, "osc", "spring", 1., gridSpacing, 0.0006, 0.0001, 0.009, 0.1);
  
  mdl.init();
  
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
  frameRate(displayRate);   

} 

// DRAW: THIS IS WHERE WE RUN THE MODEL SIMULATION AND DISPLAY IT

void draw() {
  noCursor();

  mdl.draw_physics();
  background(0);

  pushMatrix();
  translate(xOffset,yOffset, 0.);
  renderLinks(mdl);
  popMatrix();
}


void fExt(){
  String matName = "osc" + floor(random(dimX))+"_"+ floor(random(dimY));
  mdl.triggerForceImpulse(matName, random(100) , random(100), random(500));
}

void engrave(float mX, float mY, float frc){
  String matName = "osc" + floor(mX/ gridSpacing)+"_"+floor(mY/ gridSpacing);
  println(mdl.matExists(matName));
  if(mdl.matExists(matName))
    mdl.triggerForceImpulse(matName, 0. , 0., frc);
}

void chisel(float mX, float mY){
  String matName = "osc" + floor(mX/ gridSpacing)+"_"+floor(mY/ gridSpacing);
  println(mdl.matExists(matName));
  if(mdl.matExists(matName))
    mdl.removeMatAndConnectedLinks(matName);
}


void mouseDragged() {
  mouseDragged = 1;
  
}

void mouseReleased() {
  mouseDragged = 0;
}


void keyPressed() {
  if (key == ' ')
  mdl.setGravity(-0.001);
  if(keyCode == UP){
    fric += 0.001;
    mdl.setFriction(fric);
    println(fric);

  }
  else if (keyCode == DOWN){
    fric -= 0.001;
    fric = max(fric, 0);
    mdl.setFriction(fric);
    println(fric);
  }
  else if (keyCode == LEFT){
    zZoom ++;
  }
  else if (keyCode == RIGHT){
    zZoom --;
  }
}

void keyReleased() {
  if (key == ' ')
  mdl.setGravity(0.000);
}
