#include "Msp430Adc12.h"
#include "../EmbeddedCar.h"
#include <Timer.h>
#include "printf.h"

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
  uint16_t angle_now_hor, angle_now_ver;
  nx_uint8_t state, joyStickState;
  uint8_t start_count = 0;
  bool cmdBusy = TRUE;
  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Car.Start();
      call Leds.led0On();
      angle_now_hor = 3000;
      angle_now_ver = 3000;
    }
    else {
      call AMControl.start();
    }
  }

  event void Car.startDone(error_t err) {
    start_count = 1;
    call Leds.led1Toggle();
    cmdBusy = TRUE;
    call Timer0.startPeriodic(TIMER_CAR_AUTO);
  }

  event void AMControl.stopDone(error_t err) {
  }

  void start_reset();

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(DataMsg) && !cmdBusy) {
      DataMsg* dataMsg = (DataMsg*)payload;
      state = dataMsg->buttonState;
      joyStickState = dataMsg->joyStickState;
      printf("btn:%u joy:%u\n", state, joyStickState);
      printfflush();
      call Leds.led1Toggle();
      if (state & PORT_C_BIT) {
        start_reset();
      }
      else if (state & PORT_A_BIT) {
        if (angle_now_hor > 700) {
          angle_now_hor -= ANGLE_SPEED;
          call Car.Angle(angle_now_hor);
        }
      }
      else if (state & PORT_B_BIT) {
        if (angle_now_hor < 4300) {
          angle_now_hor += ANGLE_SPEED;
          call Car.Angle(angle_now_hor);
        }
      }
      else if (state & PORT_E_BIT) {
        if (angle_now_hor > 700) {
          angle_now_ver -= ANGLE_SPEED;
          call Car.Angle_Senc(angle_now_ver);
        }
      }
      else if (state & PORT_F_BIT) {
        if (angle_now_ver < 4300) {
          angle_now_ver += ANGLE_SPEED;
          call Car.Angle_Senc(angle_now_ver);
        }
      }
      else {
          if (joyStickState == STICK_NONE) {
            call Car.Pause();
          }
          else if (joyStickState == STICK_LEFT) {
            call Car.Left(500);
          }
          else if (joyStickState == STICK_RIGHT) {
            call Car.Right(500);
          }
          if (joyStickState == STICK_FORWARD) {
            call Car.Forward(500);
          }
          else if (joyStickState == STICK_BACK) {
            call Car.Back(500);
          }
      }
    }
    return msg;
  }

  void start_reset() {
    start_count = 11;
    angle_now_hor = 3000;
    angle_now_ver = 3000;
    cmdBusy = TRUE;
    call Timer0.startPeriodic(RESET_TIMER_INTERVAL);
  }

  event void Timer0.fired() {
    start_count++;
    if (start_count <= CAR_WAIT) {
      return;
    }
    if (start_count == CAR_WAIT + 1) {
      call Car.Forward(500);
    } else if (start_count == CAR_WAIT + 2) {
      call Car.Back(500);
    } else if (start_count == CAR_WAIT + 3) {
      call Car.Left(500);
    } else if (start_count == CAR_WAIT + 4) {
      call Car.Right(500);
    } else if (start_count == CAR_WAIT + 5) {
      call Car.Pause();
    } else if (start_count == CAR_WAIT + 6) {
      call Car.Angle(700);
    } else if (start_count == CAR_WAIT + 7) {
      call Car.Angle(4300);
    } else if (start_count == CAR_WAIT + 8) {
      call Car.Angle_Senc(700);
    } else if (start_count == CAR_WAIT + 9) {
      call Car.Angle_Senc(4300);
    } else if (start_count == CAR_WAIT + 10) {
      call Timer0.startPeriodic(RESET_TIMER_INTERVAL);
    } else if (start_count == CAR_WAIT + 11) {
      call Car.Angle_Senc(3000);
    } else if (start_count == CAR_WAIT + 12) {
      call Car.Angle(3000);
    } else if (start_count == CAR_WAIT + 13) {
      call Car.Angle_Third(3000);
      call Timer0.stop();
      cmdBusy = FALSE;
    }
  }

  event void Car.sendDone(error_t status) {
    call Leds.led2Toggle();
  }

  async event void Car.debug() {
    call Leds.led0Off();
  }
}
