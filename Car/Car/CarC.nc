#include "Car.c"

module CarC {
  uses interface Boot;
  uses interface Receive;
  uses interface SplitControl as AMControl;
  uses interface HplMsp430Usart;
  uses interface HplMsp430GeneralIO;
  uses interface Resource;
  uses interface HplMsp430UsartInterrupts;
  uses interface CarC;
}

implementation {
  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  command void CarC.Start() {
    call AMControl.start()
  }

  command error_t CarC.Angle(uint16_t value) {

  }
  command error_t CarC.Angle_Senc(uint16_t value) {

  }
  command error_t CarC.Angle_Third(uint16_t value) {

  }
  command error_t CarC.Forward(uint16_t value) {

  }
  command error_t CarC.Back(uint16_t value) {

  }
  command error_t CarC.Left(uint16_t value) {

  }
  command error_t CarC.Right(uint16_t value) {

  }
  command error_t CarC.QuiryReader(uint8_t value) {

  }
  command error_t CarC.Pause() {

  }
  event void CarC.readDone(error_t state, uint16_t value) {

  }
  command error_t CarC.InitMaxSpeed(uint16_t value) {

  }
  command error_t CarC.InitMinSpeed(uint16_t value) {

  }
  command error_t CarC.InitLeftServo(uint16_t value) {

  }
  command error_t CarC.InitMidServo(uint16_t value) {

  }
}
