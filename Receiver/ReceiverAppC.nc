#include "../EmbeddedCar.h"
#include <Timer.h>
#include <msp430usart.h>

configuration ReceiverAppC {
}

implementation {
  components MainC;
  components LedsC;
  components ReceiverC as App;
  components ActiveMessageC;
  components new AMReceiverC(AM_DATAMSG);
  components CarAppC;
  components new TimerMilliC() as Timer0;

  components PrintfC;
  components SerialStartC;

  App.Boot -> MainC;
  App.AMControl -> ActiveMessageC;
  App.Receive -> AMReceiverC;
  App.Car -> CarAppC.Car;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
}
