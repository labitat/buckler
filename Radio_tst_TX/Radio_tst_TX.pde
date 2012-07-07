// Test program to verify the NRF24L01 chip on Buckler board. 
// Transmitter - using the NRF24 library

#include <NRF24.h>
#include <SPI.h>   // Creates "SPI" as instance of class.

#define VOK "OK TX-0.1.0"  // Startup message

// Pin definitions
// SPI interface hardware in the chip uses pins 13, 12, 11, 10
// (10 is set to OUTPUT and has to remain OUTPUT, and is then a normal output pin)
const byte NRF_PIN_SS=2 ;        // Chip Slave Select for Radio chip - only the SPI IO
const byte ADXL_PIN_SS=5 ;       // Chip Slave Select for Accelerometer

const byte NRF_PIN_CE=4 ;        // Chip Enable - Active Radio transfer
const byte NRF_PIN_IRQ=3 ;       // Interrupt (from Radiochip to Arduino)

const byte DIODE_PIN_EN=7 ;      // Enable/Disable of diode drivers

NRF24 Nrf ( NRF_PIN_CE, NRF_PIN_SS ) ;  // Classinstance for the chip

#define BufferSize 10            // Number of bytes we send in one buffer
char Buffer[BufferSize+1] ;      // The buffer
byte BufLen = 0 ;                // Valid bytes in buffer

void init_pins() {
// Do all initalisations (SPI set by NRF24)
  pinMode(DIODE_PIN_EN,OUTPUT);digitalWrite(DIODE_PIN_EN,HIGH);// turns off LEDs (inverted logic)
  pinMode(NRF_PIN_SS, OUTPUT);    // Chip Slave Select
  digitalWrite(NRF_PIN_SS,HIGH);  // inverted logic, so HIGH is unselected
  pinMode(NRF_PIN_CE, OUTPUT);    // Chip Enable
  digitalWrite(NRF_PIN_CE,LOW);   // No (radio) activity
  pinMode(ADXL_PIN_SS, OUTPUT);   // Chip Slave Select
  digitalWrite(ADXL_PIN_SS,HIGH); // inverted logic, so HIGH is unselected
}

void setup() {
  // Serial interface startup
  Serial.begin(9600);
  // SPI/Radio chip 
  init_pins();
  Nrf.init() ;
  Nrf.setChannel(1) ;             // Comm channel - default else 2
//Nrf.setThisAddress((uint8_t*)"Tsmt1", 5) ; // Our receiver address
                                  // 5 bytes address - in this case pretty ASCII
  Nrf.setPayloadSize(BufferSize) ;// bytes transfer at a time
  Nrf.setRF(NRF24::NRF24DataRate2Mbps, NRF24::NRF24TransmitPower0dBm) ;
  Serial.println(VOK) ; // startup message with version
}

void loop() {
  // Wait for serial string, chop up into buffer, send it.
  if ( Serial.available()>0 )  {   // When we have some data
    Buffer[BufLen++]=Serial.read() ; // put it in buffer
    if (BufLen==BufferSize) {      //buffer full?
      Nrf.setTransmitAddress((uint8_t*)"Recv1", 5) ; // Who to send to
      Buffer[BufLen]=0;Serial.print(Buffer);Serial.print(">");
      Nrf.send((uint8_t*)&Buffer, BufLen) ; // Send it
      if (!Nrf.waitPacketSent()) { // Blocking wait
        Serial.println("Max RT") ; // no Ack received
      } else {
        Serial.println("OK") ; // no Ack received
      }
      BufLen = 0 ;                 // Reset buffer pointer
    }
  }
}
  



