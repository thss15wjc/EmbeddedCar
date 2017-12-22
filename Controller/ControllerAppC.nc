#include "../EmbeddedCar.h"
#include "Timer.h"
#include "printf.h"

configuration ControllerAppC {
}

implementation {
  components MainC;
  components LedsC;
  components ControllerC as App;
  components ActiveMessageC;
  components new TimerMilliC() as Timer0;
  components new AMSenderC(AM_DATAMSG);
  components JoyStickC;
  components ButtonAppC;

  components PrintfC;
  components SerialStartC;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.AMControl -> ActiveMessageC;
  App.Packet ->  AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMSend -> AMSenderC;
  App.ReadX -> JoyStickC.ReadX;
  App.ReadY -> JoyStickC.ReadY;
  App.Timer0 -> Timer0;
  App.Button -> ButtonAppC.Button;
}
