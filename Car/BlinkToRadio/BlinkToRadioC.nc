#include "Msp430Adc12.h"
#include "../EmbeddedCar.h"

module ControllerC {
  uses interface Boot;
  uses interface AMSend;
  uses interface AMPacket;
  uses interface Packet;
  uses interface SplitControl as AMControl;
  uses interface Timer<TMilli> as Timer0;
  uses interface Car;
}

implementation {
  message_t pkt;
  DataMsg curPkt;
  DataMsg oldPkt;
  bool carBusy = TRUE;

  bool check_change() {
    return !(curPkt.JoyStickX == oldPkt.JoyStickX &&
       curPkt.JoyStickY == oldPkt.JoyStickY &&
       curPkt.carState == oldPkt.carState);
  }

  void SendPacket() {
    DataMsg * collectPacket;
    if (check_change()) {
      oldPkt = curPkt;
      collectPacket = (DataMsg*)(call Packet.getPayload(&pkt, sizeof(DataMsg)));
      if (collectPacket == NULL) {
        return;
      }
      collectPacket->JoyStickX = curPkt.JoyStickX;
      collectPacket->JoyStickY = curPkt.JoyStickY;
      collectPacket->carState = curPkt.carState;
      call AMSend.send(ID_CAR, &pkt, sizeof(DataMsg));
    }
  }

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
      call Car.start();
    }
    else {
      call AMControl.start();
    }
  }

  event void Car.startDone(error_t error) {
    if (error == SUCCESS) {
      carBusy = FALSE;
    }
    else {
      call Car.start();
    }
  }

  event void Timer0.fired() {
    call ReadX.read();
    call ReadY.read();
    if (!carBusy) {
      call car.pinvalueA();
      call car.pinvalueB();
      call car.pinvalueC();
      call car.pinvalueD();
      call car.pinvalueE();
      call car.pinvalueF();
    }
    SendPacket();
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
  }

  event void Car.readDone(error_t state, uint16_t value) {
    if (state == SUCCESS) {
    }
  }
}
