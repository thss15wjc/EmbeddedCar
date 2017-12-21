#include "../EmbeddedCar.h"
#include "Timer.h"

configuration BlinkToRadioAppC {
}

implementation {
  components MainC;
  components BlinkToRadioC as App;
  components ActiveMessageC;
  components new TimerMilliC() as Timer0;
  components new Receive(AMSenderC);
  components CarAppC;

  App.Boot -> MainC;
  App.AMControl -> ActiveMessageC;
  App.Packet ->  AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMSend -> AMSenderC;
  App.Timer0 -> Timer0;
  App.Car -> CarAppC.Car;
}
