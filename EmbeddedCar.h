#ifndef EMBEDDEDCAR_H
#define EMBEDDEDCAR_H

enum {
    ID_CAR = 0xcc,
    TIMER_PERIOD_MILLI = 100,
    TIMER_CAR = 3000;
    AM_DATAMSG = 0xce,
    PORT_A_BIT = 0x1,
    PORT_B_BIT = 0x2,
    PORT_C_BIT = 0x4,
    PORT_D_BIT = 0x8,
    PORT_E_BIT = 0x16,
    PORT_F_BIT = 0x32,
    TYPE_ANGLE_1 = 0x01,
    TYPE_ANGLE_2 = 0x07,
    TYPE_ANGLE_3 = 0x08,
    TYPE_FORWARD = 0x02,
    TYPE_BACK = 0x03,
    TYPE_LEFT = 0x04,
    TYPE_RIGHT = 0x05,
    TYPE_PAUSE = 0x06
};

typedef nx_struct DataMsg {
  nx_uint16_t JoyStickX;
  nx_uint16_t JoyStickY;
  nx_uint8_t buttonState;
} DataMsg;

#endif
