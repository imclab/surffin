#include <Wire.h>
#include "I2Cdev.h"
#include "MPU9150Lib.h"
#include "CalLib.h"
#include <dmpKey.h>
#include <dmpmap.h>
#include <inv_mpu.h>
#include <inv_mpu_dmp_motion_driver.h>
#include <EEPROM.h>
#include <SD.h>

MPU9150Lib MPU;  

#define MPU_UPDATE_RATE  (20)
#define MAG_UPDATE_RATE  (20)
#define  MPU_MAG_MIX_GYRO_AND_MAG       10                  // a good mix value 
#define MPU_LPF_RATE   40  //  MPU_LPF_RATE is the low pas filter rate and can be between 5 and 188Hz

File myFile;
boolean done;
const int chipSelect = 10;

void setup()
{
  Serial.begin(9600);
  pinMode(10, OUTPUT);
  while(!Serial);
  if(!SD.begin(chipSelect)) {
    Serial.println("SD initialization failed!");
    return; 
  } 
  Serial.print("initialized");
  if(SD.exists("TEST.TXT")) {
    SD.remove("TEST.TXT");
    myFile = SD.open("TEST.TXT", FILE_WRITE);
    Serial.println("previous file deleted, file created");
  } 
  else {
    myFile = SD.open("TEST.TXT", FILE_WRITE);
    Serial.println("file created");
  }
  Wire.begin();
  done = false;

  MPU.selectDevice(0);                        // only really necessary if using device 1
  MPU.init(MPU_UPDATE_RATE, MPU_MAG_MIX_GYRO_AND_MAG, MAG_UPDATE_RATE, MPU_LPF_RATE);   // start the MPU
}

void loop()
{    
  delay(100);
  if (millis() < 10000 && !done) { 
    MPU.read();
    myFile.print("+"); 
    myFile.print(",");

    myFile.print(MPU.m_calAccel[VEC3_X]); 
    myFile.print(",");
    myFile.print(MPU.m_calAccel[VEC3_Y]); 
    myFile.print(",");
    myFile.print(MPU.m_calAccel[VEC3_Z]); 
    myFile.print(",");

    myFile.print(MPU.m_fusedEulerPose[VEC3_X]); 
    myFile.print(",");
    myFile.print(MPU.m_fusedEulerPose[VEC3_Y]); 
    myFile.print(",");
    myFile.print(MPU.m_fusedEulerPose[VEC3_Z]); 
    myFile.print(",");

    myFile.println(millis());
    Serial.print("recording  "); Serial.println(millis());
  } 
  else {
    Serial.println("done");
    myFile.close();
    done = true;
  }
}




