#ifndef EMBEDDEDCAR_H
#define EMBEDDEDCAR_H

enum {
    AM_DATAMSG = 0xce,
    PORT_A_BIT = 1,
    PORT_B_BIT = 2,
    PORT_C_BIT = 4,
    PORT_D_BIT = 8,
    PORT_E_BIT = 16,
    PORT_F_BIT = 32,
    TYPE_ANGLE_1 = 1,
    TYPE_ANGLE_2 = 7,
    TYPE_ANGLE_3 = 8,
    TYPE_FORWARD = 2,
    TYPE_BACK = 3,
    TYPE_LEFT = 4,
    TYPE_RIGHT = 5,
    TYPE_PAUSE = 6,
    STICK_LEFT = 1,
    STICK_RIGHT = 2,
    STICK_NONE = 0,
    STICK_FORWARD = 3,
    STICK_BACK = 4,
    ANGLE_SPEED = 300,
    TIMER_PERIOD_MILLI = 100,
    TIMER_CAR_AUTO = 2000,
    RESET_TIMER_INTERVAL = 100,
    CAR_WAIT = 1,
    //COMMANDMSG_BUF_LEN = 12
};

/*typedef nx_struct CommandMsg {
  nx_uint8_t type;
  nx_uint16_t value;
} CommandMsg;*/

typedef nx_struct DataMsg {
  nx_uint8_t joyStickState;
  nx_uint8_t buttonState;
} DataMsg;

#endif
