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


void setup()
{
  Serial.begin(115200);
  Wire.begin();
  done = false;
    if(!SD.begin(10)) {
      Serial.println("SD initialization failed!");
      return; 
    } 
    if(SD.exists("test.txt")) {
       SD.remove("test.txt");
       myFile = SD.open("test.txt", FILE_WRITE);
    } else {
       myFile = SD.open("test.txt", FILE_WRITE);
    }
    
  MPU.selectDevice(0);                        // only really necessary if using device 1
  MPU.init(MPU_UPDATE_RATE, MPU_MAG_MIX_GYRO_AND_MAG, MAG_UPDATE_RATE, MPU_LPF_RATE);   // start the MPU
}

void loop()
{  
  if (MPU.read() && millis() < 6000 && !done) { 
    myFile.print(MPU.m_calAccel[VEC3_X]); myFile.print(",");
    myFile.print(MPU.m_calAccel[VEC3_Y]); myFile.print(",");
    myFile.print(MPU.m_calAccel[VEC3_Z]); myFile.print(",");
    
    myFile.print(MPU.m_fusedEulerPose[VEC3_X]); myFile.print(",");
    myFile.print(MPU.m_fusedEulerPose[VEC3_Y]); myFile.print(",");
    myFile.print(MPU.m_fusedEulerPose[VEC3_Z]); myFile.print(",");
    
    Serial.println(millis());
  } else {
    myFile.close();
    Serial.println("RECORDING COMPLETE!");
    done = true; 
  }
}
