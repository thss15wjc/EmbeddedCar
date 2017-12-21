configuration CarAppC {
  provides interface Car;
}

implementation {
  components new HplMsp430Usart0C() as HplMsp430Usart0C;
  components new Msp430Usart0C() as Msp430Usart0C;
  components new HplMsp430GeneralIOC() as GIO;
  components CarC;

  CarC.HplMsp430GeneralIO -> GIO.HplMsp430GeneralIO;
  CarC.P20 -> GIO.Port20;
  CarC.HplMsp430Usart -> HplMsp430Usart0C.HplMsp430Usart;
  CarC.HplMsp430UsartInterrupts -> HplMsp430Usart0C.HplMsp430UsartInterrupts;
  CarC.Resource -> Msp430Usart0C.Resource;
}
