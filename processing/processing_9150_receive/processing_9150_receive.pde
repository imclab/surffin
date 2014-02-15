import processing.serial.*;
import toxi.geom.*;
import toxi.processing.*;
import saito.objloader.*;

ToxiclibsSupport gfx;
OBJModel model;
Serial port;  
Quaternion quat;


void setup() {
  size(800, 500, OPENGL); 
  
//  println(Serial.list());
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
    translate(width / 2, height / 2); 
//    rotateX(rotX * -1);
//    rotateY(rotZ *-1 + PI/2);
//    rotateZ(rotY * -1);
    float[] axis = quat.toAxisAngle();
    rotateY(PI/2);
    rotate(axis[0], -axis[1], -axis[3], -axis[2]);
    model.draw();
  popMatrix();
}


void serialEvent(Serial port) {
  String rawData = port.readStringUntil(36); // '$' = ascii #36
  if(rawData != null) {
    String[] vals = rawData.split(",");
    float rotX = float(vals[4]);
    float rotY = float(vals[5]);
    float rotZ = float(vals[6]); 
    quat = new Quaternion().createFromEuler(rotY, rotZ, rotX);
  }
}
