#include "BlinkToRadio.h"

configuration BlinkToRadioAppC {
}

implementation {
  components MainC;
  components BlinkToRadioC as App;
  components ActiveMessageC;
  components new AMSenderC(AM_BUTTON_SEND);
  components new JoyStickAppC() as JoyStickAppC;

  App.Boot -> MainC;
  App.AMControl -> ActiveMessageC;
  App.Packet ->  AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMSend -> AMSenderC;
  App.ReadX -> JoyStickAppC.ReadX;
  App.ReadY -> JoyStickAppC.ReadY;
}
