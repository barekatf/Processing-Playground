// Making analogRead faster 
#define FASTADC 1
// defines for setting and clearing register bits
#ifndef cbi
#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#endif
#ifndef sbi
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))
#endif
//*******************************
// Sensor variables 
int val = 0; 

void setup() {
  // setup Serial comm with computer 
  Serial.begin(57600); 
  pinMode(A0, INPUT); 

  // Setting prescaler for making analogRead faster 
#if FASTADC
  // set prescale to 16
  sbi(ADCSRA,ADPS2) ;
  cbi(ADCSRA,ADPS1) ;
  cbi(ADCSRA,ADPS0) ;
#endif
}

void loop() {
  val = analogRead(A0); 
  sendData(val); 
}
//*******************************

void sendData(int value) {
  Serial.write( 0xff );                                                         
  Serial.write( (value >> 8) & 0xff );                                            
  Serial.write( value & 0xff );
}

