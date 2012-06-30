/*-------------------------------------------------------*\
| Buckler diode functions                                 |
|                                                         |
| The main units is in another .PDE file                  |
\*-------------------------------------------------------*/

#define VOK "Diode 0.01 " 

// Pin defenitions
const byte DIODE_PIN_LATCH=9 ; // Freeze pin out
const byte DIODE_PIN_CLK=10 ;  // Clock netx bit
const byte DIODE_PIN_DAT=8 ;   // Data bit
const byte DIODE_PIN_EN=7 ;    // Enable/Disable

enum RGY = { RED, GRN, YEL } ;
/* =========\\
|| Setup    ||
\\ =========*/

/*-----------------------------------------*\
| setup_diode : Do the necessary setup      |
|  (Serial assumed avail for message)       |
\------------------------------------------*/
void setup_diode() {
  pinMode(DIODE_PIN_LATCH,OUTPUT);
  pinMode(DIODE_PIN_CLK,OUTPUT);
  pinMode(DIODE_PIN_DAT,OUTPUT);
  pinMode(DIODE_PIN_EN,OUTPUT);  
  digitalWrite(DIODE_PIN_EN, HIGH); // disable output (all Off)
  Serial.print(VOK) ;
}

/* =========\\
|| Drawing  ||
\\ =========*/

/*-----------------------------------------------------------*\
| diode_box : draw a box                                      |
|   size pixels (1-6), offset X, Y (1-8), Col (RED, GRN, YEL) |
\------------------------------------------------------------*/
void diode_box ( byte Size, byte Xoff, byte Yoff, RGY Col ) {
}

/*--------------------------------------------------------------*\
| diode_char : draw a character                                  |
|   code (ASCII: 32-127), offset X, Y (1-8), Col (RED, GRN, YEL) |
| Lower case is given as uppercase. Unimplemented chars          |
| display as "dot-in-middle". Some invalid codes have a graphic  |
\---------------------------------------------------------------*/
void diode_chr ( byte Code, byte Xoff, byte Yoff, byte Col ) {
}

/* ======================\\
|| (Local) IO functions  ||
\\ ======================*/
// These can still be called directly, of course
