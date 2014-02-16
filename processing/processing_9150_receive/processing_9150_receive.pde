import processing.serial.*;
import toxi.geom.*;
import toxi.processing.*;
import saito.objloader.*;

ToxiclibsSupport gfx;
OBJModel model;
Serial port;  
Quaternion quat;

PVector loc   = new PVector();
PVector accel = new PVector();
PVector vel   = new PVector();
PVector force = new PVector();

float gravity = 2.8;


void setup() {
  size(800, 500, OPENGL); 
  
  println(Serial.list());
  String portName = Serial.list()[7];
  port = new Serial(this, portName, 115200);
  //port.bufferUntil(36);
  
  model = new OBJModel(this, "surf.obj", "absolute", TRIANGLES);
  model.scale(2);
  model.translateToCenter();

}

void draw() {
  background(200);
  stroke(0);
 
  pushMatrix();
    translate(width / 2 + loc.x, height / 2 + loc.y, loc.z); 
//    rotateX(rotX * -1);
//    rotateY(rotZ *-1 + PI/2);
//    rotateZ(rotY * -1);
    float[] axis = quat.toAxisAngle();
    rotateY(PI/2);
    rotate(axis[0], -axis[1], -axis[3], -axis[2]);
    model.draw();
  popMatrix();
  
  vel.x = 0;
  vel.y = 0;
  vel.z = 0;
  
  accel.x = 0;
  accel.y = 0;
  accel.z = 0;
}


void serialEvent(Serial port) {
  String rawData = port.readStringUntil(36); // '$' = ascii #36
  if(rawData != null) {
    println(rawData.trim());
    String[] vals = rawData.split(",");
    
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
    loc.sub(vel); 
  }
}
