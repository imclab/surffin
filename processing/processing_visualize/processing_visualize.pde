import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
import toxi.geom.*;
import toxi.processing.*;

ToxiclibsSupport gfx;
PeasyCam cam;

float gravity = 2.8;
int boxCounter;
int prevTime;

String[] rawData;
ArrayList<Coordinate> allCoordinates = new ArrayList<Coordinate>();


void setup() {
  size(800, 500, OPENGL); 
  colorMode(HSB);
  cam = new PeasyCam(this, 100);

  rawData = loadStrings("shake.txt");
  parseTextFile("shake.txt");
}

void draw() {
  background(40);

 // center axis
  fill(100);
  box(5);
  stroke(255, 255, 255);
  line(0, 0, 0, 100, 0, 0);
  stroke(80, 255, 255);
  line(0, 0, 0, 0, 100, 0);
  stroke(180, 255, 255);
  line(0, 0, 0, 0, 0, 100);

  stroke(255);
  noFill();
  
  drawBoxes(boxCounter);

  if(millis() % 3 == 0) {
    boxCounter++;
    if(boxCounter >= allCoordinates.size()-1) {
      boxCounter = 0;
    }
  } 
}

void drawBoxes(int _counter) {
  for(int i=1; i < _counter; i++) {
    Coordinate c = allCoordinates.get(i);
    Coordinate pc = allCoordinates.get(i-1);
    c.display();
    stroke(i-1*(255/allCoordinates.size()), 255, 255);
    line(pc.loc.x, pc.loc.y, pc.loc.z, c.loc.x, c.loc.y, c.loc.z);
    //println(c.loc.x + " : " + c.loc.y + " : " + c.loc.z);
  } 
}


void parseTextFile(String _name) {
  PVector prevLoc = new PVector();
  int prevTime = 0;
  
  for (int i=0; i<rawData.length; i++) {
    if (rawData[i] != null) {    
      String[] vals = rawData[i].trim().split(",");
      Coordinate c = new Coordinate();
      int timestamp = int(vals[7]);
      println(timestamp);
      float deltaTime = timestamp - prevTime;
      
      // gyro data
      float rotX = float(vals[4]);
      float rotY = float(vals[5]);
      float rotZ = float(vals[6]); 
      c.quat = new Quaternion().createFromEuler(rotY, rotZ, rotX);
      
      // accelerometer data
      c.force.x = int(vals[1]) / deltaTime;
      c.force.z = int(vals[2]) / deltaTime;
      c.force.y = int((int(vals[3])/ deltaTime));

      // calculate position
      //c.force.mult(15);
      c.accel = c.force;
      c.vel.add(c.accel);
      c.loc.add(c.vel); 
      allCoordinates.add(c);

      prevLoc = c.loc;
      prevTime = timestamp;
    }
  }
}

