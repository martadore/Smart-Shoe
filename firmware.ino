#include <Adafruit_MPU6050.h>
Adafruit_MPU6050 mpu;
Adafruit_Sensor *mpu_accel;

#define pinLed1 3
#define pinLed2 5
#define pinLed3 9
#define pinLed4 11

//Global variables definition:
int Medial_Forefoot;
int Lateral_Midfoot;
int Medial_Midfoot;
int Heel;

void setup() {
  Serial.begin(115200);

  //Initialization LEDs:
  pinMode(pinLed1, OUTPUT);
  pinMode(pinLed2, OUTPUT);
  pinMode(pinLed3, OUTPUT);
  pinMode(pinLed4, OUTPUT);

  while (!Serial)
    delay(10); // will pause Zero, Leonardo, etc until serial console opens

  if (!mpu.begin()) {
    while (1) {
      delay(10);
    }
  }
  mpu_accel = mpu.getAccelerometerSensor();

}

void loop() {
  sensors_event_t accel;
  mpu_accel->getEvent(&accel);
  
  Medial_Forefoot = analogRead(A0);
  if (Medial_Forefoot < 50) {
    Medial_Forefoot = 0;
  }
  Serial.print(Medial_Forefoot);
  Serial.print(",");
  Lateral_Midfoot = analogRead(A1);
  if (Lateral_Midfoot < 50) {
    Lateral_Midfoot = 0;
  }
  Serial.print(Lateral_Midfoot);
  Serial.print(",");
  Medial_Midfoot = analogRead(A2);
  if (Medial_Midfoot < 50) {
    Medial_Midfoot = 0;
  }
  Serial.print(Medial_Midfoot);
  Serial.print(",");
  Heel = analogRead(A3);
  if (Heel < 50) {
    Heel = 0;
  }
  Serial.print(Heel);
  Serial.print(",\n");
  Serial.print(accel.acceleration.x);
  Serial.print(",");
  Serial.print(accel.acceleration.y);
  Serial.print(",");
  Serial.print(accel.acceleration.z);
  Serial.print(",\n");

  //Set PWM signal for LEDs: analogWrite(pin, value)
  analogWrite(pinLed1, round((Medial_Forefoot*255)/1023));
  analogWrite(pinLed2, round((Lateral_Midfoot*255)/1023));
  analogWrite(pinLed3, round((Medial_Midfoot*255)/1023));
  analogWrite(pinLed4, round((Heel*255)/1023));

  delay(300);
}
