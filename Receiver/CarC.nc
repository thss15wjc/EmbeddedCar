#include <msp430usart.h>

module CarC {
  uses interface HplMsp430Usart;
  uses interface HplMsp430GeneralIO as P20;
  uses interface Resource;
  uses interface HplMsp430UsartInterrupts;
  provides interface Car;
}

implementation {
  uint8_t command_type;
  uint16_t command_value;
  /*CommandMsg cmdBuf[COMMANDMSG_BUF_LEN];
  CommandMsg curMsg, sendMsg;
  uint8_t cmdIn = 0;
  uint8_t cmdOut = 0;*/
  bool cmdBusy = TRUE;
  //bool cmdFull = TRUE;

  uint8_t sending_state;
  msp430_uart_union_config_t config1 = {
    {
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
    }
  };

  command void Car.Start() {
    /*cmdIn = 0;
    cmdOut = 0;*/
    cmdBusy = FALSE;
    /*cmdFull = FALSE;*/
    sending_state = 0;
  }

  command error_t Car.Angle(uint16_t value) {
    command_type = TYPE_ANGLE_1;
    command_value = value;
    if (!cmdBusy) {
      call Resource.request();
      cmdBusy = TRUE;
    }
    /*if (!cmdFull) {
      cmdBuf[cmdIn] = curMsg;
      cmdIn = (cmdIn + 1) % COMMANDMSG_BUF_LEN;
      if (cmdIn == cmdOut) {
        cmdFull = TRUE;
      }
      if (!cmdBusy) {
        call Resource.request();
        cmdBusy = TRUE;
      }
    }*/
    return SUCCESS;
  }

  command error_t Car.Angle_Senc(uint16_t value) {
    command_type = TYPE_ANGLE_2;
    command_value = value;
    if (!cmdBusy) {
      call Resource.request();
      cmdBusy = TRUE;
    }
    return SUCCESS;
  }

  command error_t Car.Angle_Third(uint16_t value) {
    command_type = TYPE_ANGLE_3;
    command_value = value;
    if (!cmdBusy) {
      call Resource.request();
      cmdBusy = TRUE;
    }
    return SUCCESS;
  }

  command error_t Car.Forward(uint16_t value) {
    //command_type = TYPE_FORWARD;
    command_type = TYPE_LEFT;
    command_value = value;
    if (!cmdBusy) {
      call Resource.request();
      cmdBusy = TRUE;
    }
    return SUCCESS;
  }

  command error_t Car.Back(uint16_t value) {
    //command_type = TYPE_BACK;
    command_type = TYPE_RIGHT;
    command_value = value;
    if (!cmdBusy) {
      call Resource.request();
      cmdBusy = TRUE;
    }
    return SUCCESS;
  }

  command error_t Car.Left(uint16_t value) {
    //command_type = TYPE_LEFT;
    command_type = TYPE_BACK;
    command_value = value;
    if (!cmdBusy) {
      call Resource.request();
      cmdBusy = TRUE;
    }
    return SUCCESS;
  }

  command error_t Car.Right(uint16_t value) {
    //command_type = TYPE_RIGHT;
    command_type = TYPE_FORWARD;
    command_value = value;
    if (!cmdBusy) {
      call Resource.request();
      cmdBusy = TRUE;
    }
    return SUCCESS;
  }

  command error_t Car.QuiryReader(uint8_t value) {
    return SUCCESS;
  }

  command error_t Car.Pause() {
    command_type = TYPE_PAUSE;
    command_value = 0;
    if (!cmdBusy) {
      call Resource.request();
      cmdBusy = TRUE;
    }
    return SUCCESS;
  }

  command error_t Car.InitMaxSpeed(uint16_t value) {
    return SUCCESS;
  }

  command error_t Car.InitMinSpeed(uint16_t value) {
    return SUCCESS;
  }

  command error_t Car.InitLeftServo(uint16_t value) {
    return SUCCESS;
  }

  command error_t Car.InitRightServo(uint16_t value) {
    return SUCCESS;
  }

  command error_t Car.InitMidServo(uint16_t value) {
    return SUCCESS;
  }

  void send_command();

  void prepare_command() {
    call HplMsp430Usart.setModeUart(&config1);
    call HplMsp430Usart.enableUart();
    U0CTL &= ~SYNC;
    sending_state = 0;
    //sendMsg = cmdBuf[cmdOut];
    send_command();
    call Resource.release();
    cmdBusy = FALSE;
    signal Car.sendDone(SUCCESS);
  }

  void send_command() {
    switch (sending_state) {
    case 0:
      call HplMsp430Usart.tx(1);
      break;
    case 1:
      call HplMsp430Usart.tx(2);
      break;
    case 2:
      call HplMsp430Usart.tx(command_type);
      break;
    case 3:
      call HplMsp430Usart.tx((uint8_t)((command_value >> 8) & 0xff));
      break;
    case 4:
      call HplMsp430Usart.tx((uint8_t)(command_value & 0xff));
      break;
    case 5:
      call HplMsp430Usart.tx(0xFF);
      break;
    case 6:
      call HplMsp430Usart.tx(0xFF);
      break;
    case 7:
      call HplMsp430Usart.tx(0x00);
      break;
    default:
      break;
    }
    ++sending_state;
    if (sending_state < 8) {
      while (!(call HplMsp430Usart.isTxEmpty() == SUCCESS)) {
        // NOTHING TODO
      }
      send_command();
    }
    else {
      /*call Resource.release();
      signal Car.sendDone(SUCCESS);
      cmdOut = (cmdOut + 1) % COMMANDMSG_BUF_LEN;
      if (cmdFull) {
        cmdFull = FALSE;
      }
      if (cmdIn == cmdOut && !cmdFull) {
        cmdBusy = FALSE;
        return;
      }
      prepare_command();*/
    }
  }

  default event void Car.sendDone(error_t state) {
  }

  default async event void Car.debug() {
  }

  async event void HplMsp430UsartInterrupts.txDone() {
    signal Car.debug();
  }

  async event void HplMsp430UsartInterrupts.rxDone(uint8_t data) {
    // NOTHING TODO
  }

  event void Resource.granted() {
    prepare_command();
  }
}
