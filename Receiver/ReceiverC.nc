#include "Msp430Adc12.h"
#include "../EmbeddedCar.h"

module ReceiverC {
  uses interface Boot;
  uses interface Leds;
  uses interface Receive;
  uses interface SplitControl as AMControl;
  uses interface Car;
}

implementation {
  message_t pkt;

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Car.Start();
      call Leds.led0On();
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
      uint8_t state = dataMsg->buttonState;
      uint8_t joyX = dataMsg->JoyStickX;
      uint8_t joyY = dataMsg->JoyStickY;
    	printf("JoyStickX:%u, JoyStickY: %u, ButtonState: %u\n", dataMsg->JoyStickX, dataMsg->JoyStickY, dataMsg->buttonState);
    	printfflush();
      call Leds.led1Toggle();
      if (state & PORT_E_BIT) {
        call Car.Pause();
      }
      else if (state & PORT_A_BIT) {
        call Car.Angle(2700);
      }
      else if (state & PORT_B_BIT) {
        call Car.Angle_Senc(2700);
      }
      else if (state & PORT_C_BIT) {
        call Car.Angle_Third(2700);
      }
      else {
        if (joyX & STICK_LEFT) {
          call Car.Left(500);
        }
        else if (joyX & STICK_RIGHT) {
          call Car.Right(500);
        }
        else {
          if (joyY & STICK_FORWARD) {
            call Car.Forward(500);
          }
          else if (joyY & STICK_BACK) {
            call Car.Back(500);
          }
          else {
            call Car.Pause();
          }
        }
      }
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

  event void Car.sendDone(error_t state) {
    call Leds.led2Toggle();
  }

  async event void Car.debug() {
    call Leds.led0Off();
  }
}
