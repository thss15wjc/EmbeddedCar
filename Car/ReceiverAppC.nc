#include "../EmbeddedCar.h"
#include <msp430usart.h>

configuration ReceiverAppC {
}

implementation {
  components MainC;
  components ReceiverC as App;
  components ActiveMessageC;
  components new AMReceiverC(AM_DATAMSG);
  components CarAppC;

  App.Boot -> MainC;
  App.AMControl -> ActiveMessageC;
  App.Receive -> AMReceiverC;
  App.Car -> CarAppC.Car;
}
