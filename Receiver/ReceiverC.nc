#include "Msp430Adc12.h"
#include "../EmbeddedCar.h"
#include <Timer.h>

module ReceiverC {
  uses interface Boot;
  uses interface Leds;
  uses interface Receive;
  uses interface SplitControl as AMControl;
  uses interface Car;
  uses interface Timer<TMilli> as Timer0;
}

implementation {
  message_t pkt;
  uint8_t angle_now_hor, angle_now_ver;
  uint8_t state, joyX, joyY;
  uint8_t reset_status;
  bool command_busy = FALSE;
  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Car.Start();
      call Leds.led0On();
      angle_now_hor = 2500;
      angle_now_ver = 2500;
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    printf("Receive\n");
    printfflush();
    if (len == sizeof(DataMsg)) {
      DataMsg* dataMsg = (DataMsg*)payload;
      state = dataMsg->buttonState;
      joyX = dataMsg->JoyStickX;
      joyY = dataMsg->JoyStickY;
    	printf("JoyStickX:%u, JoyStickY: %u, ButtonState: %u\n", dataMsg->JoyStickX, dataMsg->JoyStickY, dataMsg->buttonState);
    	printfflush();
      //call Leds.led1Toggle();
      /*if (!command_busy) {
        command_busy = TRUE;
        call Timer0.startPeriodic(TIMER_CAR);*/
        if (state & PORT_C_BIT) {
          call Car.Pause();
        }
        else if (state & PORT_A_BIT) {
          angle_now_hor -= ANGLE_SPEED;
          if (angle_now_hor > 700) {
            call Car.Angle(angle_now_hor);
          }
        }
        else if (state & PORT_B_BIT) {
          angle_now_hor += ANGLE_SPEED;
          if (angle_now_hor < 4300) {
            call Car.Angle(angle_now_hor);
          }
        }
        else if (state & PORT_E_BIT) {
          angle_now_ver -= ANGLE_SPEED;
          if (angle_now_hor > 700) {
            call Car.Angle_Senc(angle_now_ver);
          }
        }
        else if (state & PORT_F_BIT) {
          angle_now_ver += ANGLE_SPEED;
          if (angle_now_ver < 4300) {
            call Car.Angle_Senc(angle_now_ver);
          }
        }
        else if (state & PORT_D_BIT) {
          call Car.Reset();
          reset_status = 1;
        }
        else {
          if (joyY == STICK_NONE && joyX == STICK_NONE) {
            call Car.Pause();
          }
          else {
            if (joyX == STICK_LEFT) {
              call Car.Left(500);
            }
            else if (joyX == STICK_RIGHT) {
              call Car.Right(500);
            }
            if (joyY == STICK_FORWARD) {
              call Car.Forward(500);
            }
            else if (joyY == STICK_BACK) {
              call Car.Back(500);
            }
          }
        }
      //}
      /*if (state & PORT_A_BIT) {
        call Car.Forward(500);
        //A is right
      }
      else if (state & PORT_B_BIT) {
        call Car.Back(500);
        //b is left
      }
      else if (state & PORT_C_BIT) {
        call Car.Left(500);
        //c is forward
      }
      else if (state & PORT_D_BIT) {
      }
      else if (state & PORT_E_BIT) {
        call Car.Pause();
      }
      else if (state & PORT_F_BIT) {
        call Car.Right(500);
        //f is backward
      }*/
    }
    return msg;
  }

  event void Timer0.fired() {
    command_busy = FALSE;
    call Timer0.stop();
  }

  event void Car.sendDone(error_t status) {
    call Leds.led2Toggle();
    if (status == SUCCESS) {
      if (reset_status == 1) {
        call Car.Angle_Senc(2500);
        reset_status = 2;
      } else if (reset_status == 2) {
        call Car.Angle_Third(2500);
        reset_status = 0;
      }
    }
  }

  async event void Car.debug() {
    call Leds.led0Off();
  }
}
