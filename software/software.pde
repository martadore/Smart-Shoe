import g4p_controls.*;
import processing.serial.*;
import java.util.*;

import java.lang.Math;

Serial myPort;
String val;    

//FSR:
Vector<Integer> val1 = new Vector<Integer>();
Vector<Integer> val2 = new Vector<Integer>();
Vector<Integer> val3 = new Vector<Integer>();
Vector<Integer> val4 = new Vector<Integer>();

//Accelerometer:
Vector<Integer> val5 = new Vector<Integer>();
Vector<Integer> val6 = new Vector<Integer>();
Vector<Integer> val7 = new Vector<Integer>();

int lastStepTime = 0;

int name_ok = 0;
int age_ok = 0;
int gender_ok = 0;
int height_ok = 0;
int set_age = 0;
int set_gender = 0;
int set_height = 0;
int set_weight = 0;

String name;
String gender;
int age;
int height_user;
int weight;
int bio_inserted = 0;
float BMR = 0;

int mode_one = 0;
int mode_two = 0;
int mode_three = 0;
int mode_four = 0;
int stop = 0;
String phase = "";
String phase1 = "";
String phase2 = "";

int calibration = 0;
int startTime = 0;
int calibration_finished = 0;
int velocity = 0;
int measurement = 0;
int init = 0;
int initTime = 0;
int startStep = 0;
int searchEndStep = 0;
float step_length = 0;
int step = 0;
int step_tot = 0;
int searchEndStride = 0;
float stride_length = 0;
int cadence = 0;

int start = 0;
int profile = 1;
//int MFP_oneREF = 0;
float MFP1_final = 0;
float MFP2_final = 0;
float MFP3_final = 0;
float MFP4_final = 0;
float MFP5_final = 0;
float MFP_final = 0;
int MFP_one = 0;
//int MFP_twoREF = 0;
int MFP_two = 0;
//int MFP_threeREF = 0;
int MFP_three = 0;
//int MFP_fourREF = 0;
int MFP_four = 0;
//int MFP_fiveREF = 0;
int MFP_five = 0;
int i = 0;
int startTest = 0;
int test = 0;
int MFP = 0;

float time_still = 0;
float time_motion = 0;

float calories = 0;

PImage bg;

public void setup(){
  size(780, 870, JAVA2D);
  
  createGUI();
  customGUI();
  bg = loadImage("foot.png");
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 115200);
}

public void draw(){
  background(230);
  
  if(name_ok == 1){
    set_age = 1;
  }
  if(age_ok == 1){
    set_gender = 1;
  }
  if(gender_ok == 1){
    set_height = 1;
  }
  if(height_ok == 1){
    set_weight = 1;
  }
  
  if(bio_inserted == 1){
    background(bg);
    
    if(gender == "male"){
      BMR = (13.397*weight) + (4.799*height_user) - (5.677*age) + 88.362;
    }else{
      BMR = (9.247*weight) + (3.098*height_user) - (4.33*age) + 447.593;
    }
    
    PImage mode1 = loadImage("mode1.png");
    PImage mode2 = loadImage("mode2.png");
    PImage mode3 = loadImage("mode3.png");
    PImage mode4 = loadImage("mode4.png");
    PImage pause = loadImage("stop.png");
    PImage button = loadImage("button.png");
    PImage m1 = loadImage("m1.png");
    PImage m2 = loadImage("m2.png");
    PImage m3 = loadImage("m3.png");
    PImage m4 = loadImage("m4.png");
    
    fill(0); //text black
    textFont(createFont("calibri", 15));
    text("Function: ", 65, 35);
    image(mode1, 64, 43, 70, 70);
    text("Function: ", 155, 35);
    image(mode2, 150, 43, 70, 70);
    text("Function: ", 243, 35);
    image(mode3, 236, 43, 70, 70);
    text("Function: ", 330, 35);
    image(mode4, 320, 43, 70, 70);
    image(pause, 460, 42, 70, 70);
    text("Calibration button: ", 440, 130);
    image(button, 465, 135, 60, 60);
    
    /*
    stroke(255, 255, 255);
    fill(255, 255, 255);
    circle(120, 460, 25);  //white
    stroke(0, 0, 255);
    fill(0, 0, 255);    
    circle(208, 525, 25);  //blue
    stroke(0, 255, 0);
    fill(0, 255, 0);   
    circle(125, 560, 25);  //green
    stroke(255, 255, 0);
    fill(255, 255, 0); 
    circle(130, 700, 25);  //yellow*/
    
    fill(0);
    textSize(20);
    text("Name: " + name, 590, 35);
    text("Age: "+ age, 590, 68);
    text("Gender: " + gender, 590, 101);
    text("Height: " + height_user + " cm", 590, 139);
    text("Weight: " + weight + " kg", 590, 172);
    
    fill(255,255,255);
    stroke(255);
    rect(390, 210, 300, 40);
    fill(0);
    textSize(30);
    text("Status: " + phase, 300, 260);
    textSize(20);
    
    image(m1, 400, 340, 45, 45);
    text("MODE 1: ", 450, 350);
    text("Step length: " + step_length + "cm", 450, 370);
    text("Stride length: " + stride_length + "cm", 450, 390);
    text("Cadence: " + cadence, 450, 410);
    text("Step count: " + step, 450, 430);
    
    image(m2, 400, 450, 35, 35);
    text("MODE 2: ", 450, 460);
    text("ref1: " + MFP1_final, 450, 480);
    text("ref2: " + MFP2_final, 450, 500);
    text("ref3: " + MFP3_final, 450, 520);
    text("ref4: " + MFP4_final, 450, 540);
    text("ref5: " + MFP5_final, 450, 560);
    text("MFP: " + MFP_final, 450, 580);
    text("Profile of walking: " + phase1, 450, 600);
    
    image(m3, 400, 620, 40, 40);
    text("MODE 3: ", 450, 630);
    text("User's status: " + phase2, 450, 650);
    text("Period of activity: ", 450, 670);
    textSize(15);
    text(time_still + "s still", 450, 690);
    text(time_motion + "s in motion", 450, 710);
    
    image(m4, 400, 730, 35, 35);
    textSize(20);
    text("MODE 4: ", 450, 740);
    text("Calories burnt: " + calories + " kcal", 450, 760);
    text("BMR: " + BMR + " kcal", 450, 780);
   
    if (myPort.available() > 0) {
      val = myPort.readStringUntil('\n');
      if (millis() - lastStepTime > 200){
        if (val != null) {
          String[] arrOfStr = val.split(",");
          int mf = Integer.parseInt(arrOfStr[0]);
          int lf = Integer.parseInt(arrOfStr[1]);
          int mm = Integer.parseInt(arrOfStr[2]);
          int heel = Integer.parseInt(arrOfStr[3]);
          
          float acc_x = Float.parseFloat(arrOfStr[4]);
          float acc_y = Float.parseFloat(arrOfStr[5]);
          float acc_z = Float.parseFloat(arrOfStr[6]);
        
          //dispaly fsr data on the UI:
           if(mf > 0 && mf < 255){
            stroke(255, 255, 255);
            fill(255, 255, 255);
            circle(140, 395, 25);  //white
          }else if(mf >= 255 && mf < 511){
            stroke(255, 255, 255);
            fill(255, 255, 255);
            circle(140, 395, 25);  
            circle(140, 395, 60);
          }else if(mf >= 511 && mf < 767){
            stroke(255, 255, 255);
            fill(255, 255, 255);
            circle(140, 395, 25);  
            circle(140, 395, 80);
          }else if(mf > 767 && mf <= 1023){
            stroke(255, 255, 255);
            fill(255, 255, 255);
            circle(140, 395, 25); 
            circle(140, 395, 100);
          }
          
          if(lf > 0 && lf < 255){
            stroke(0, 0, 255);
            fill(0, 0, 255);
            circle(260, 510, 25);  //blue
          }else if(lf >= 255 && lf < 511){
            stroke(0, 0, 255);
            fill(0, 0, 255);
            circle(260, 510, 25);  
            circle(260, 510, 60);
          }else if(lf >= 511 && lf < 767){
            stroke(0, 0, 255);
            fill(0, 0, 255);
            circle(260, 510, 25);  
            circle(260, 510, 80);
          }else if(lf > 767 && lf <= 1023){
            stroke(0, 0, 255);
            fill(0, 0, 255);
            circle(260, 510, 25);  
            circle(260, 510, 100);
          }
          
          if(mm > 0 && mm < 255){
            stroke(0, 255, 0);
            fill(0, 255, 0);   
            circle(125, 560, 25);  //green
          }else if(mm >= 255 && mm < 511){
            stroke(0, 255, 0);
            fill(0, 255, 0);   
            circle(125, 560, 25);  
            circle(125, 560, 60);
          }else if(mm >= 511 && mm < 767){
            stroke(0, 255, 0);
            fill(0, 255, 0);   
            circle(125, 560, 25);  
            circle(125, 560, 80);
          }else if(mm > 767 && mm <= 1023){
            stroke(0, 255, 0);
            fill(0, 255, 0);   
            circle(125, 560, 25);  
            circle(125, 560, 100);
          }
          
          if(heel > 0 && heel < 255){
            stroke(255, 255, 0);
            fill(255, 255, 0); 
            circle(180, 770, 25);  //yellow
          }else if(heel >= 255 && heel < 511){
            stroke(255, 255, 0);
            fill(255, 255, 0); 
            circle(180, 770, 25);  
            circle(180, 770, 60);
          }else if(heel >= 511 && heel < 767){
            stroke(255, 255, 0);
            fill(255, 255, 0); 
            circle(180, 770, 25);  
            circle(180, 770, 80);
          }else if(heel > 767 && heel <= 1023){
            stroke(255, 255, 0);
            fill(255, 255, 0); 
            circle(180, 770, 25); 
            circle(180, 770, 100);
          }
          
          if(mode_one == 1){
            if(calibration == 0){
              startTime = millis();
              calibration = 1;
            }
            if(calibration == 0 ||(calibration == 1 && calibration_finished == 1)){
              phase = "calibration";
            }
            
            if(calibration == 1 && calibration_finished == 1){
              velocity = round(200/((millis()-startTime)/1000)); //velocity = space[cm]/time[s]
              println("Velocity: " + velocity);
              phase = "calibration done!";
              fill(0);
              text("velocity: " + velocity + "cm/s", 75, 200);
              measurement = 1;
              calibration_finished = 0;
              delay(300);
             }
             if(measurement == 1){
               phase = "measurement";
               if(init == 0){
                 initTime = millis();
                 init = 1;
               }
               if(init == 1){
                 if(heel != 0 && searchEndStep == 0){
                   startStep = millis();
                   searchEndStep = 1;
                 }
                 if(searchEndStep == 1){
                   if(searchEndStride == 0){
                     if(heel == 0){
                       if(mf == 0){
                         step_length = float(velocity)*(((millis()-startStep)/1000.00));   
                         step++;
                         searchEndStride = 1;
                       }
                     }
                   }
                   if(searchEndStride == 1){
                     if(heel != 0){
                       stride_length = float(velocity)*(((millis()-startStep)/1000.00));    
                       println("stride_length: " + stride_length);
                       searchEndStride = 0;
                       searchEndStep = 0;
                     }
                   }
                 }
                 
                 if(millis()-initTime > 60000){
                   cadence = step;
                   step_tot += step;
                   step = 0;
                 }
                 
                 if(millis()-initTime > 120000){
                   println("Measurement finished");
                   phase = "measurement finished";
                   init = 0;
                   searchEndStep = 0;
                   searchEndStride = 0;
                   delay(100);
                 }
             }
           }    
         }
         
         if(mode_two == 1){
           
           if(init == 0){
             start = millis();
             init = 1;
           }
           if(init == 0 || init == 1){
             if(profile == 1){
               phase = "normal gait";
               println("normal gait");
             }else if(profile == 2){
               phase = "in-toeing";
               println("in-toeing");
             }else if(profile == 3){
               phase = "out-toeing";
               println("out-toeing");
             }else if(profile == 4){
               phase = "tiptoeing";
               println("tiptoeing");
             }else if(profile == 5){
               phase = "walking on the heel";
               println("walking on the heel");
             }
           }
           if(init == 1){
             if(profile == 1){
               MFP_one += ((mm + mf)*100)/(mm + mf + lf + heel + 0.001);
               i++;
             }
             if(profile == 2){
               MFP_two += ((mm + mf)*100)/(mm + mf + lf + heel + 0.001);
               i++;
             }
             if(profile == 3){
               MFP_three += ((mm + mf)*100)/(mm + mf + lf + heel + 0.001);
               i++;
             }
             if(profile == 4){
               MFP_four += ((mm + mf)*100)/(mm + mf + lf + heel + 0.001);
               i++;
             }
             if(profile == 5){
               MFP_five += ((mm + mf)*100)/(mm + mf + lf + heel + 0.001);
               i++;
             }
             if((millis()-start) > 20000){
               if(profile == 1){
                 println("MFP_ref1 computed!");
                 //MFP_oneREF =  MFP_one;
                 MFP1_final = MFP_one/i;
               }
               if(profile == 2){
                  println("MFP_ref2 computed!");
                 //MFP_twoREF =  MFP_two;
                 MFP2_final = MFP_two/i;
               }
               if(profile == 3){
                 //MFP_threeREF =  MFP_three;
                 MFP3_final = MFP_three/i;
               }
               if(profile == 4){
                 //MFP_fourREF =  MFP_four;
                 MFP4_final = MFP_four/i;
               }
               if(profile == 5){
                // MFP_fiveREF =  MFP_five;
                 MFP5_final = MFP_five/i;
               }
               if(profile != 5){
                 profile += 1;
                 i = 0;
                 init = 0;
               }else{
                 test = 1;
                 i = 0;
               }
             }
           }
           if(test == 1){
             phase = "test";
             delay(100);
             //println(millis());
             if(startTest == 0){
               start = millis();
               startTest = 1;
             }
             if(startTest == 1){
                MFP += ((mm + mf)*100)/(mm + mf + lf + heel + 0.001);
                i++;
                if((millis()-start) > 20000){
                  MFP_final = MFP/i;
                  if(MFP > .95*MFP1_final || MFP < 1.05*MFP1_final){
                    phase1 = "normal gait";
                    delay(100);
                  }
                  if(MFP > .95*MFP2_final || MFP < 1.05*MFP2_final){
                    phase1 = "in-toeing!";
                    delay(100);
                  }
                  if(MFP > .95*MFP3_final || MFP < 1.05*MFP3_final){
                    phase1 = "out-toeing!";
                    delay(100);
                  }
                  if(MFP > .95*MFP4_final || MFP < 1.05*MFP4_final){
                    phase1 = "tiptoeing!";
                    delay(100);
                  }
                  if(MFP > .95*MFP5_final || MFP < 1.05*MFP5_final){
                    phase1 = "walking on the heel!";
                    delay(100);
                  }
                  startTest=0;
                  MFP = 0;
                  i=0;
                }
             }
           }
         }
         
        if(mode_three == 1){
          println(acc_x);
          println(acc_y);
          println(acc_z);
          
          if((Math.abs(acc_x) > 7 && Math.abs(acc_x) < 12) && 
              Math.abs(acc_y) < 5 &&
              (Math.abs(acc_z) > 4 && Math.abs(acc_z) < 8)){ 
            phase2 = "standing still";
            time_still += .2; //[s]
           // println(time_still);
          } else { 
            phase2 = "in motion";
            time_motion += .2; //[s]
           // println(time_motion);
          }
        }
       
        if(mode_four == 1){
          //you need to perform mode 1 before
          calories = step_tot*0.063;
        }
        
        lastStepTime = millis();
        }
      }
    }
  }
}

void keyPressed()
{
  if(key == ENTER && name_ok == 0){
    name = ask_name.getText();
    println(name);
    name_ok = 1;
  }
  if(key == ENTER && name_ok == 1 && set_age == 1){
    age = int(ask_age.getText());
    println(age);
    age_ok = 1;
  }
  if(key == ENTER && age_ok == 1 && set_gender == 1){
    gender = ask_gender.getText();
    println(gender);
    gender_ok = 1;
  }
  if(key == ENTER && gender_ok == 1 && set_height == 1){
    height_user = int(ask_height.getText());
    println(height_user);
    height_ok = 1;
  }
  
  if(key == ENTER && height_ok == 1 && set_weight == 1){
    weight = int(ask_weight.getText());
    println(weight);   
    label1.setVisible(false);
    label2.setVisible(false);
    label3.setVisible(false);
    label4.setVisible(false);
    label5.setVisible(false);
    ask_name.setVisible(false);
    ask_age.setVisible(false);
    ask_gender.setVisible(false);
    ask_height.setVisible(false);
    ask_weight.setVisible(false);
    imgButton1.setVisible(false);
    bio_inserted = 1;
  }
  if (key == 'x' || key == 'X')
  {
    exit();
  }
}

void mousePressed() {
  if( sqrt( sq(64 - mouseX) + sq(75 - mouseY)) < 70/2){
    mode_one = 1;
    phase = "function 1";
    println("Function 1");
  }
/*  if( sqrt( sq(64 - mouseX) + sq(150 - mouseY)) < 70/2){
    calibration_finished = 1;
    println("Calibration finished");
  }*/
  if( sqrt( sq(150 - mouseX) + sq(75 - mouseY)) < 70/2){
    mode_two = 1;
    phase = "function 2";
    println("Function 2");
  }
  if( sqrt( sq(246 - mouseX) + sq(75 - mouseY)) < 70/2){
    mode_three = 1;
    phase = "function 3";
    println("Function 3");
  }
   if( sqrt( sq(332 - mouseX) + sq(75 - mouseY)) < 70/2){
    mode_four = 1;
    phase = "function 4";
    println("Function 4");
  }
  if( sqrt( sq(460 - mouseX) + sq(150- mouseY)) < 70/2){
    calibration_finished = 1;
    println("Calibration finished");
  }  
  if( sqrt( sq(460 - mouseX) + sq(75- mouseY)) < 70/2){
    stop = 1;
    phase = "stop";
    println("Stop!");
    mode_one = 0;
    mode_two = 0;
    mode_three = 0;
    mode_four = 0;
  }  
}


public void customGUI(){

}
