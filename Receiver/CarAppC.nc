#include <msp430usart.h>
#include <Timer.h>

configuration CarAppC {
  provides interface Car;
}

implementation {
  components HplMsp430Usart0C;
  components new Msp430Usart0C() as Msp430Usart0C;
  components HplMsp430GeneralIOC as GIO;
  components CarC;
  components new TimerMilliC() as Timer0;

  CarC.P20 -> GIO.Port20;
  CarC.HplMsp430Usart -> HplMsp430Usart0C.HplMsp430Usart;
  CarC.HplMsp430UsartInterrupts -> HplMsp430Usart0C.HplMsp430UsartInterrupts;
  CarC.Resource -> Msp430Usart0C.Resource;
  CarC.Timer0 -> Timer0;
  Car = CarC.Car;
}
