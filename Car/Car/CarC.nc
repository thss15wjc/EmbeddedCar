#include "Car.c"

module CarC {
  uses interface Receive;
  uses interface SplitControl as AMControl;
  uses interface HplMsp430Usart as Usart;
  uses interface HplMsp430GeneralIO as GIO;
  uses interface Resource as UsartResource[uint16_t id];
  uses interface HplMsp430UsartInterrupts as UsartInterrupts[uint8_t id];
  uses interface CarC;
  provides interface setModeUart<const msp430_uart_union_config_t*> as setModeUart;
}

implementation {
  bool isTxEmpty = TRUE;
  msp430_uart_union_config_t config1 = {
    utxe: 1,
    urxe: 1,
    ubr: UBR_1MHZ_115200,
    umctl: UMCTL_1MHZ_115200,
    ssel: 0x02,
    pena: 0,
    pev: 0,
    spb: 0,
    clen: 1,
    listen: 0,
    mm: 0,
    ckpl: 0,
    urxse: 0,
    urxeie: 0,
    urxwie: 0,
    utxe: 1,
    urxe: 1
  };
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
    call UsartResource[value].request();
    signal UsartResource.granted[value]();
    return SUCCESS;
  }

  command error_t CarC.Angle(uint16_t value) {
    call UsartResource[value].request();
    signal UsartResource.granted[value]();
    return SUCCESS;
  }
  command error_t CarC.Angle_Senc(uint16_t value) {
    call UsartResource[value].request();
    signal UsartResource.granted[value]();
    return SUCCESS;
  }
  command error_t CarC.Angle_Third(uint16_t value) {
    call UsartResource[value].request();
    signal UsartResource.granted[value]();
    return SUCCESS;
  }
  command error_t CarC.Forward(uint16_t value) {
    call UsartResource[value].request();
    signal UsartResource.granted[value]();
    return SUCCESS;
  }
  command error_t CarC.Back(uint16_t value) {
    call UsartResource[value].request();
    signal UsartResource.granted[value]();
    return SUCCESS;
  }
  command error_t CarC.Left(uint16_t value) {
    call UsartResource[value].request();
    signal UsartResource.granted[value]();
    return SUCCESS;
  }
  command error_t CarC.Right(uint16_t value) {
    call UsartResource[value].request();
    signal UsartResource.granted[value]();
    return SUCCESS;
  }
  command error_t CarC.QuiryReader(uint8_t value) {
    call UsartResource[value].request();
    signal UsartResource.granted[value]();
    return SUCCESS;
  }
  command error_t CarC.Pause() {
    call UsartResource[value].request();
    signal UsartResource.granted[value]();
    return SUCCESS;
  }
  event void CarC.readDone(error_t state, uint16_t value) {
    if (state == SUCCESS) {
      call UsartResource[value].request();
      signal UsartResource.granted[value]();
    }
  }
  command error_t CarC.InitMaxSpeed(uint16_t value) {
    call UsartResource[value].request();
    signal UsartResource.granted[value]();
    return SUCCESS;
  }
  command error_t CarC.InitMinSpeed(uint16_t value) {
    call UsartResource[value].request();
    signal UsartResource.granted[value]();
    return SUCCESS;
  }
  command error_t CarC.InitLeftServo(uint16_t value) {
    call UsartResource[value].request();
    signal UsartResource.granted[value]();
    return SUCCESS;
  }
  command error_t CarC.InitMidServo(uint16_t value) {
    call UsartResource[value].request();
    signal UsartResource.granted[value]();
    return SUCCESS;
  }
  async event void UsartInterrupts.txDone() {
    isTxEmpty = TRUE;
  }
  event void UsartResource.granted[uint16_t id]() {
    call Usart.setModeUart(config1);
    call Usart.enableUart();
    U0CTL &= ~SYNC;
    if (isTxEmpty == TRUE) {
        call Usart.tx(id);
        isTxEmpty = FALSE;
    }
    call UsartResource[id].release();
  }
}
