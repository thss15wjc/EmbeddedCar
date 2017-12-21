module ButtonC {
  uses interface HplMsp430GeneralIO as PortA;
  uses interface HplMsp430GeneralIO as PortB;
  uses interface HplMsp430GeneralIO as PortC;
  uses interface HplMsp430GeneralIO as PortD;
  uses interface HplMsp430GeneralIO as PortE;
  uses interface HplMsp430GeneralIO as PortF;
  provides interface Button;
}

implementation {

  command void Button.start() {
    call PortA.clr();
    call PortB.clr();
    call PortC.clr();
    call PortD.clr();
    call PortE.clr();
    call PortF.clr();
    call PortA.makeInput();
    call PortB.makeInput();
    call PortC.makeInput();
    call PortD.makeInput();
    call PortE.makeInput();
    call PortF.makeInput();
    signal Button.startDone(SUCCESS);
  }

  default event void Button.startDone(error_t error) {
    if (error == SUCCESS) {
    }
    else {
      call Button.start();
    }
  }

  command void Button.stop() {
    signal Button.stopDone(SUCCESS);
  }

  default event void Button.stopDone(error_t error) {
    if (error == SUCCESS) {
    }
    else {
      call Button.stop();
    }
  }

  command void Button.pinvalueA() {
    signal Button.pinvalueADone(call PortA.get());
  }

  default event void Button.pinvalueADone(error_t error) {
  }

  command void Button.pinvalueB() {
    signal Button.pinvalueADone(call PortB.get());
  }

  default event void Button.pinvalueBDone(error_t error) {
  }

  command void Button.pinvalueC() {
    signal Button.pinvalueADone(call PortC.get());
  }

  default event void Button.pinvalueCDone(error_t error) {
  }

  command void Button.pinvalueD() {
    signal Button.pinvalueADone(call PortD.get());
  }

  default event void Button.pinvalueDDone(error_t error) {
  }

  command void Button.pinvalueE() {
    signal Button.pinvalueADone(call PortE.get());
  }

  default event void Button.pinvalueEDone(error_t error) {
  }

  command void Button.pinvalueF() {
    signal Button.pinvalueADone(call PortF.get());
  }

  default event void Button.pinvalueFDone(error_t error) {
  }
}
