#include "Msp430Adc12.h"
#include "../EmbeddedCar.h"

module ReceiverC {
  uses interface Boot;
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
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(DataMsg)) {
      DataMsg* dataMsg = (DataMsg*)payload;
      uint8_t state = dataMsg->buttonState;
      if (state & PORT_A_BIT) {
        call Car.Forward(500);
      }
      else if (state & PORT_B_BIT) {
        call Car.Back(500);
      }
      else if (state & PORT_C_BIT) {
        call Car.Left(500);
      }
      else if (state & PORT_D_BIT) {
        call Car.Right(500);
      }
      else if (state & PORT_E_BIT) {
        call Car.Pause();
      }
      else if (state & PORT_F_BIT) {

      }
    }
    return msg;
  }
}
