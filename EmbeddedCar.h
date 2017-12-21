#ifndef EMBEDDEDCAR_H
#define EMBEDDEDCAR_H

enum {
    ID_CAR = 0xcc,
    TIMER_PERIOD_MILLI = 100,
    AM_DATAMSG = 0xce,
    PORT_A_BIT = 0x1,
    PORT_B_BIT = 0x2,
    PORT_C_BIT = 0x4,
    PORT_D_BIT = 0x8,
    PORT_E_BIT = 0x16,
    PORT_F_BIT = 0x32
};

typedef nx_struct DataMsg {
  nx_uint16_t JoyStickX;
  nx_uint16_t JoyStickY;
  nx_uint8_t buttonState;
} DataMsg;

#endif
