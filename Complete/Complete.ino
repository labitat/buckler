/*-------------------------------------------------------*\
| Buckler Main routine, complete with all devices busy    |
|                                                         |
| The subunits are in their own .PDE files                |
\*-------------------------------------------------------*/

#define VOK "Main 0.1.2"

#include <SPI.h>  // Defines and invokes a single instance of class SPI
#include <memoryFree.h>

enum RGY { RED, GRN, YEL } ;

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
  setup_accel_deselect() ; // Must set all spi devices to deselect first
  setup_radio_deselect() ; // (could be solved with an external pullup)
// Do all initalisations for SPI
  SPI.begin() ;        // Initialises SPI pins and SPI protocol
  SPI.setDataMode(SPI_MODE3); // Set for IdleHighSCK and SampleTrailEdge clock mode
}

/* ==========\\
|| Main Loop ||
\\ ==========*/
void loop() {
  static int runs = 10 ;         // counter of loop runs
  if ( runs--<0 ) {              // after a number of loop runs:
    Serial.print("Free bytes") ; Serial.println(memoryFree()) ;
    while(true) ;               // "stop" here
  }
//  diode_test() ;
//  accel_test();
//  accel_balance() ; 
  radio_test();
}

/*--------------------------------------------------------*\
| Various examples                                         |
\*--------------------------------------------------------*/

void accel_balance() {
  int XYZ[3] ;
  accel_read_xyz(XYZ) ;
  diode_box(constrain(map(XYZ[1], -100,+100, 0,8),0,7), 
            constrain(map(XYZ[0], -100,+100, 0,8),0,7),
            1, 1, GRN ) ;
}

/*--------------------------------------------------------*\
| Various test routines                                    |
\*--------------------------------------------------------*/
  
void diode_test() {
  diode_box(0,0,1,1,RED) ; delay(400) ;
  diode_box(1,1,2,2,GRN) ; delay(400) ;
  diode_box(2,2,3,3,YEL) ; delay(400) ;
  for (int i=1; i<400/2; i++) {
    diode_box(0,0,2,8,GRN) ; diode_box(0,0,8,2,GRN) ; delay(2) ;
    }
  diode_off() ; delay(400) ;
  diode_chr('L',0,0,GRN) ; delay(555) ;
}
      
void accel_test() {
  boolean Test ;
  int Values[3] ;
  accel_read_xyz(Values) ;
  for (int i=0; i<3;i++) {
    Serial.print(Values[i]) ;
    Serial.print(" ");
  }
  Test = accel_test_xyz(Values) ;
  for (int i=0; i<3; i++) {
    Serial.print(Values[i]) ;
    Serial.print(" ");
  }
  if ( Test ) Serial.println("Yes") ; else Serial.println("No") ;
}

void radio_test() {
}

