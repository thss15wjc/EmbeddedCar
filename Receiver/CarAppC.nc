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

  CarC.P20 -> GIO.Port20;
  CarC.HplMsp430Usart -> HplMsp430Usart0C.HplMsp430Usart;
  CarC.Resource -> Msp430Usart0C.Resource;
  Car = CarC.Car;
}
