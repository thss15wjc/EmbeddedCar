#include "Msp430Adc12.h"
#include "../EmbeddedCar.h"

module ControllerC {
  uses interface Boot;
  uses interface Leds;
  uses interface AMSend;
  uses interface AMPacket;
  uses interface Packet;
  uses interface SplitControl as AMControl;
  uses interface Timer<TMilli> as Timer0;
  uses interface Read<uint16_t> as ReadX;
  uses interface Read<uint16_t> as ReadY;
  uses interface Button;
}

implementation {
  message_t pkt;
  DataMsg curPkt;
  DataMsg oldPkt;
  uint16_t JoyStickX, JoyStickY;
  bool buttonBusy = TRUE;

  void set_joy_stick_state() {
    if (JoyStickX > 1000 && JoyStickX < 3000 && JoyStickY > 1000 && JoyStickY < 3000) {
      curPkt.joyStickState = STICK_NONE;
    }
    else if (JoyStickX > 3000 && JoyStickY > 4500 - JoyStickX && JoyStickY < JoyStickX) {
      curPkt.joyStickState = STICK_LEFT;
    }
    else if (JoyStickX < 1000 && JoyStickY < 4500 - JoyStickX && JoyStickY > JoyStickX) {
      curPkt.joyStickState = STICK_RIGHT;
    }
    else if (JoyStickY < 1000 && JoyStickX < 4500 - JoyStickY && JoyStickY < JoyStickX) {
      curPkt.joyStickState = STICK_FORWARD;
    }
    else if (JoyStickY > 3000 && JoyStickX > 4500 - JoyStickY && JoyStickY > JoyStickX) {
      curPkt.joyStickState = STICK_BACK;
    }
    else {
      curPkt.joyStickState = STICK_NONE;
    }
  }

  bool check_send() {
    return !(curPkt.joyStickState == oldPkt.joyStickState &&
       !(curPkt.buttonState & 63));
  }

  void SendPacket() {
    DataMsg * collectPacket;
    if (check_send()) {
      oldPkt = curPkt;
      printf("JoyStickState:%u\n", curPkt.joyStickState);
    	printfflush();
      call Leds.led2Toggle();
      collectPacket = (DataMsg*)(call Packet.getPayload(&pkt, sizeof(DataMsg)));
      if (collectPacket == NULL) {
        return;
      }
      collectPacket->joyStickState = curPkt.joyStickState;
      collectPacket->buttonState = curPkt.buttonState;
      call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(DataMsg));
    }
  }

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      oldPkt.buttonState = 0;
      oldPkt.joyStickState = STICK_NONE;
      curPkt.buttonState = 0;
      curPkt.joyStickState = STICK_NONE;
      call Leds.led1On();
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
      call Button.start();
    }
    else {
      call AMControl.start();
    }
  }

  event void Button.startDone(error_t error) {
    if (error == SUCCESS) {
      buttonBusy = FALSE;
    }
    else {
      call Button.start();
    }
  }

  event void Timer0.fired() {
    call ReadX.read();
    call ReadY.read();
    if (!buttonBusy) {
      call Button.pinvalueA();
      call Button.pinvalueB();
      call Button.pinvalueC();
      call Button.pinvalueD();
      call Button.pinvalueE();
      call Button.pinvalueF();
    }
    atomic {
      set_joy_stick_state();
      SendPacket();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Button.stopDone(error_t error) {
    if (error == SUCCESS) {
    }
    else {
      call Button.stop();
    }
  }

  event void Button.pinvalueADone(error_t error) {
      if (!error) {
        curPkt.buttonState |= PORT_A_BIT;
      }
      else {
        curPkt.buttonState &= ~PORT_A_BIT;
      }
  }

  event void Button.pinvalueBDone(error_t error) {
      if (!error) {
        curPkt.buttonState |= PORT_B_BIT;
      }
      else {
        curPkt.buttonState &= ~PORT_B_BIT;
      }
  }

  event void Button.pinvalueCDone(error_t error) {
      if (!error) {
        curPkt.buttonState |= PORT_C_BIT;
      }
      else {
        curPkt.buttonState &= ~PORT_C_BIT;
      }
  }

  event void Button.pinvalueDDone(error_t error) {
      /*if (!error) {
        curPkt.buttonState |= PORT_D_BIT;
      }
      else {
        curPkt.buttonState &= ~PORT_D_BIT;
      }*/
      curPkt.buttonState &= ~PORT_D_BIT;
  }

  event void Button.pinvalueEDone(error_t error) {
      if (!error) {
        curPkt.buttonState |= PORT_E_BIT;
      }
      else {
        curPkt.buttonState &= ~PORT_E_BIT;
      }
  }

  event void Button.pinvalueFDone(error_t error) {
      if (!error) {
        curPkt.buttonState |= PORT_F_BIT;
      }
      else {
        curPkt.buttonState &= ~PORT_F_BIT;
      }
  }

  event void ReadX.readDone(error_t result, uint16_t data)
  {
    if (result == SUCCESS){
      JoyStickX = data;
      /*if (data < 1000) {
        curPkt.JoyStickY = STICK_FORWARD;
      }
      else if (data > 3000) {
        curPkt.JoyStickY = STICK_BACK;
      }
      else {
        curPkt.JoyStickY = STICK_NONE;
      }*/
    }
    /*else {
      curPkt.JoyStickY = STICK_NONE;
    }*/
  }

  event void ReadY.readDone(error_t result, uint16_t data)
  {
    if (result == SUCCESS){
      JoyStickY = data;
      /*if (data < 1000) {
        curPkt.JoyStickX = STICK_RIGHT;
      }
      else if (data > 3000) {
        curPkt.JoyStickX = STICK_LEFT;
      }
      else {
        curPkt.JoyStickX = STICK_NONE;
      }*/
    }
    /*else {
      curPkt.JoyStickX = STICK_NONE;
    }*/
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
  }
}
