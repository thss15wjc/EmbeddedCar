#include <Timer.h>
#include "Button.h"

configuration ButtonAppC {

}

implementation {
  components MainC;
  components ButtonAppC as App;
  components new HplMsp430GeneralIOC() as HplMsp430GeneralIOC;
  components Button;
  Button.PortA = HplMsp430GeneralIOC.Port60;
  Button.PortB = HplMsp430GeneralIOC.Port21;
  Button.PortC = HplMsp430GeneralIOC.Port61;
  Button.PortD = HplMsp430GeneralIOC.Port23;
  Button.PortE = HplMsp430GeneralIOC.Port62;
  Button.PortF = HplMsp430GeneralIOC.Port26;
  Button.HplMsp430GeneralIO -> HplMsp430GeneralIOC.HplMsp430GeneralIO;
}

interface Button {
  command void Start();
  event void startDone(error_t error);
  command void stop();
  event void stopDone(error_t error);
  command void pinvalueA();
  event void pinvalueADone(error_t error);
  command void pinvalueB();
  event void pinvalueBDone(error_t error);
  command void pinvalueC();
  event void pinvalueCDone(error_t error);
  command void pinvalueD();
  event void pinvalueDDone(error_t error);
  command void pinvalueE();
  event void pinvalueEDone(error_t error);
  command void pinvalueF();
  event void pinvalueFDone(error_t error);
}
