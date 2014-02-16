import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import toxi.geom.*;
import toxi.processing.*;
import saito.objloader.*;


ToxiclibsSupport gfx;
OBJModel model;
PeasyCam cam;

float gravity = 2.8;
int boxCounter;

String[] rawData;


void setup() {
  size(800, 500, OPENGL); 
  colorMode(HSB);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);

  rawData = loadStrings("shake.txt");

  //  model = new OBJModel(this, "surf.obj", "absolute", TRIANGLES);
  //  model.scale(2);
  //  model.translateToCenter();
}

void draw() {
  background(200);

  fill(100);
  box(5);
  stroke(255, 0, 0);
  line(0, 0, 0, 100, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 100, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 100);

  stroke(0);
  noFill();

  parseTextFile("shake.txt");
}

void parseTextFile(String _name) {
  PVector prevLoc = new PVector();
  
  for (int i=0; i<rawData.length; i++) {
    if (rawData[i] != null) {
      String[] vals = rawData[i].trim().split(",");
      // data holders
      PVector loc   = new PVector();
      PVector accel = new PVector();
      PVector vel   = new PVector();
      PVector force = new PVector();
      Quaternion quat;


      // gyro data
      float rotX = float(vals[4]);
      float rotY = float(vals[5]);
      float rotZ = float(vals[6]); 
      quat = new Quaternion().createFromEuler(rotY, rotZ, rotX);

      // accelerometer data
      force.x = int(vals[1]) / 1023;
      force.z = int(vals[2]) / 1023;
      force.y = int((int(vals[3])/ 1023) - gravity);
      //println(accel.x + " : " + accel.y + " : " + accel.z);

      // calculate adjustments
      force.mult(5);
      accel = force;
      vel.add(accel);
      vel.mult(5);
      loc.sub(vel);

      pushMatrix();
      translate(loc.x, loc.y, loc.z); 
      float[] axis = quat.toAxisAngle();
      rotateY(PI/2);
      rotate(axis[0], -axis[1], -axis[3], -axis[2]);
      box(3);
      popMatrix();
      
      stroke(i*0.25, 255, 255);
      line(prevLoc.x, prevLoc.y, prevLoc.z, loc.x, loc.y, loc.z);
      
      prevLoc = loc;
    }
  }
}

