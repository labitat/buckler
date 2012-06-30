/*-------------------------------------------------------*\
| Buckler Main routine, complete with all devices busy    |
|                                                         |
| The subunits are in their own .PDE files                |
\*-------------------------------------------------------*/

#define VOK "Main 0.01"

#include <SPI.h>  // Defines and invokes a single instance of class SPI
#include <memoryFree.h>


/* =========\\
|| Setup    ||
\\ =========*/
void setup() {
  Serial.begin(9600) ;
  setup_spi() ;
  setup_diode() ;
  setup_accel() ;
  setup_radio() ;
  Serial.println(VOK) ;
}

void setup_spi() {
  setup_accel_deselect() ; // Must set all spi devices to Deselect first
  setup_radio_deselect() ; // (could be solved with an external pullup)
// Do all initalisations for SPI
  SPI.begin() ;        // Initialises SPI pins and SPI protocol
  SPI.setDataMode(SPI_MODE3); // Set for IdleHighSCK and SampleTrailEdge clock mode
}

/* ==========\\
|| Main Loop ||
\\ ==========*/
void loop() {
  delay(2222) ;
  Serial.print("Free bytes") ; Serial.println(memoryFree()) ;
}


