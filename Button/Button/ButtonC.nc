#include "Button.h"

module Button {
  uses interface Boot;
  uses interface Receive;
  uses interface SplitControl as AMControl;
  provides interface HplMsp430GeneralIO as PortA;
  provides interface HplMsp430GeneralIO as PortB;
  provides interface HplMsp430GeneralIO as PortC;
  provides interface HplMsp430GeneralIO as PortD;
  provides interface HplMsp430GeneralIO as PortE;
  provides interface HplMsp430GeneralIO as PortF;
}

implementation {
  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Button.Start();
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  command void Button.Start() {
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
  }

  event void Button.startDone(error_t error) {
    if (error == SUCCESS) {
      call Button.pinvalueA();
      call Button.pinvalueB();
      call Button.pinvalueC();
      call Button.pinvalueD();
      call Button.pinvalueE();
      call Button.pinvalueF();
    }
    else {
      call Button.start();
    }
  }
  command void Button.stop() {

  }
  event void Button.stopDone(error_t error) {
    if (error == SUCCESS) {
    }
    else {
      call Button.stop();
    }
  }
  command void Button.pinvalueA() {
    bool success;
    success = call PortA.get();
    if (success == 1) {
      signal Button.pinvalueADone(SUCCESS)
    } else {
    }
  }
  event void Button.pinvalueADone(error_t error) {
    if (error == SUCCESS) {
    }
    else {
      call Button.pinvalueA();
    }
  }
  command void Button.pinvalueB() {
    bool success;
    success = call PortB.get();
    if (success == 1) {
      signal Button.pinvalueADone(SUCCESS)
    } else {
    }
  }
  event void Button.pinvalueBDone(error_t error) {
    if (error == SUCCESS) {
    }
    else {
      call Button.pinvalueB();
    }
  }
  command void Button.pinvalueC() {
    bool success;
    success = call PortC.get();
    if (success == 1) {
      signal Button.pinvalueADone(SUCCESS)
    } else {
    }
  }
  event void Button.pinvalueCDone(error_t error) {
    if (error == SUCCESS) {
    }
    else {
      call Button.pinvalueC();
    }
  }
  command void Button.pinvalueD() {
    bool success;
    success = call PortD.get();
    if (success == 1) {
      signal Button.pinvalueADone(SUCCESS)
    } else {
    }
  }
  event void Button.pinvalueDDone(error_t error) {
    if (error == SUCCESS) {
    }
    else {
      call Button.pinvalueD();
    }
  }
  command void Button.pinvalueE() {
    bool success;
    success = call PortE.get();
    if (success == 1) {
      signal Button.pinvalueADone(SUCCESS)
    } else {
    }
  }
  event void Button.pinvalueEDone(error_t error) {
    if (error == SUCCESS) {
    }
    else {
      call Button.pinvalueE();
    }
  }
  command void Button.pinvalueF() {
    bool success;
    success = call PortF.get();
    if (success == 1) {
      signal Button.pinvalueADone(SUCCESS)
    } else {
    }
  }
  event void Button.pinvalueFDone(error_t error) {
    if (error == SUCCESS) {
    }
    else {
      call Button.pinvalueF();
    }
  }
}
