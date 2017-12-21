interface Car {
  command void Start();
  command error_t Angle(uint16_t value);
  command error_t Angle_Senc(uint16_t value);
  command error_t Angle_Third(uint16_t value);
  command error_t Forward(uint16_t value);
  command error_t Back(uint16_t value);
  command error_t Left(uint16_t value);
  command error_t Right(uint16_t value);
  command error_t QuiryReader(uint8_t value);
  command error_t Pause();
  //event void readDone(error_t state, uint16_t value);
  command error_t InitMaxSpeed(uint16_t value);
  command error_t InitMinSpeed(uint16_t value);
  command error_t InitLeftServo(uint16_t value);
  command error_t InitMidServo(uint16_t value);
}
