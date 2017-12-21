#include <Msp430Adc12.h>

configuration JoyStickC {
  provides interface Read<uint16_t> as ReadX;
  provides interface Read<uint16_t> as ReadY;
}

implementation {
  components new AdcReadClientC() as ReadClientX;
  components new AdcReadClientC() as ReadClientY;
  ReadX = ReadClientX.Read;
  ReadY = ReadClientY.Read;
  components JoyStickP;
  ReadClientX.AdcConfigure -> JoyStickP.AdcConfigureX;
  ReadClientY.AdcConfigure -> JoyStickP.AdcConfigureY;
}
