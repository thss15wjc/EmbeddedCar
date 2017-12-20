#include "Msp430Adc12.h"
#include "BlinkToRadio.h"

module BlinkToRadioC {
  uses interface Boot;
  uses interface AMSend;
  uses interface AMPacket;
  uses interface SplitControl as AMControl;
  uses interface Read<uint16_t> as ReadX;
  uses interface Read<uint16_t> as ReadY;
}

implementation {
  message_t pkt;
  message_t rpkt;
  JoyStickMsg * msgrPkt;
  JoyStickMsg msgPkt;
  bool JoyStickBusy = FALSE;
  uint16_t count = 0;
  void SendPacket() {
    if (JoyStickBusy) {
      JoyStickMsg* collectPacket = (JoyStickMsg*)(call Packet.getPayload(&pkt, sizeof(JoyStickMsg)));
      if (collectPacket == NULL) {
        return;
      }
      collectPacket->JoyStickX = msgPkt.JoyStickX;
      collectPacket->JoyStickY = msgPkt.JoyStickY;
      if (!(call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(JoyStickMsg)) == SUCCESS)) {
        JoyStickBusy = FALSE;
      }
    }
  }

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call ReadX.read();
      call ReadY.read();
      if (!JoyStickBusy) {
        JoyStickBusy = TRUE;
        SendPacket();
      }
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void ReadX.readDone(error_t result, uint16_t data)
  {
    if (result == SUCCESS){
      if (!JoyStickBusy) {
        msgPkt.JoyStickX = data;
      }
    }
  }

  event void ReadY.readDone(error_t result, uint16_t data)
  {
    if (result == SUCCESS){
      if (!JoyStickBusy) {
        msgPkt.JoyStickY = data;
      }
    }
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      JoyStickBusy = FALSE;
      count++;
    }
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(JoyStickMsg)) {
      msgrPkt = (JoyStickMsg*)payload;
      post SendReceive();
    }
    return msg;
  }
}
