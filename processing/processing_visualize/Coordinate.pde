class Coordinate {

  PVector loc   = new PVector();
  PVector accel = new PVector();
  PVector vel   = new PVector();
  PVector force = new PVector();
  Quaternion quat;

  Coordinate() {
  }

  void display() {
    pushMatrix();
      translate(loc.x, loc.y, loc.z);
      stroke(255, 255, 255);
      line(0, 0, 0, 40, 0, 0);
      stroke(80, 255, 255);
      line(0, 0, 0, 0, 40, 0);
      stroke(180, 255, 255);
      line(0, 0, 0, 0, 0, 40); 
      float[] axis = quat.toAxisAngle();
      rotateY(PI/2);
      rotate(axis[0], -axis[1], -axis[3], -axis[2]);
      stroke(255);
      fill(255, 100);
      box(20);
    popMatrix();
  }
}

