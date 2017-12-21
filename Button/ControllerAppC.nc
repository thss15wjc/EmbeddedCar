#include "../EmbeddedCar.h"
#include "Timer.h"

configuration ControllerAppC {
}

implementation {
  components MainC;
  components ControllerC as App;
  components ActiveMessageC;
  components new TimerMilliC() as Timer0;
  components new AMSenderC(AM_DATAMSG);
  components JoyStickC;
  components ButtonAppC;

  App.Boot -> MainC;
  App.AMControl -> ActiveMessageC;
  App.Packet ->  AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMSend -> AMSenderC;
  App.ReadX -> JoyStickC.ReadX;
  App.ReadY -> JoyStickC.ReadY;
  App.Timer0 -> Timer0;
  App.Button -> ButtonAppC.Button;
}
