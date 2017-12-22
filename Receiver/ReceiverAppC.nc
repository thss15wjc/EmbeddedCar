#include "../EmbeddedCar.h"
#include <msp430usart.h>
#include "printf.h"

configuration ReceiverAppC {
}

implementation {
  components MainC;
  components LedsC;
  components ReceiverC as App;
  components ActiveMessageC;
  components new AMReceiverC(AM_DATAMSG);
  components CarAppC;

  components PrintfC;
  components SerialStartC;

  App.Boot -> MainC;
  App.AMControl -> ActiveMessageC;
  App.Receive -> AMReceiverC;
  App.Car -> CarAppC.Car;
  App.Leds -> LedsC;
}
