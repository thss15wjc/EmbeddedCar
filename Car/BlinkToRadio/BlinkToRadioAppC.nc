#include <Timer.h>
#include "BlinkToRadio.h"

configuration CarAppC {

}

implementation {
  components MainC;
  components BlinkToRadioC as App;
  components new TimerMilliC() as Timer;
  components ActiveMessageC;
  components new AMReceiverC(AM_CAR_RECEIVE);

  App.Boot -> MainC;
  App.Timer -> Timer;
  App.AMControl -> ActiveMessageC;
  App.Receive ->  AMReceiverC;
}
