#ifndef BLINKTORADIO_H
#define BLINKTORADIO_H

enum {
    AM_CAR_RECEIVE = 0xce
    AM_BUTTON_SEND = 0xcf
    LENGTH = 100
};

typedef nx_struct JoyStickMsg {
  nx_uint16_t JoyStickX;
  nx_uint16_t JoyStickY;
  nx_uint8_t JoyStickState;
} DirectCollectorMsg;

#endif
