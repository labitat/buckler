/*-------------------------------------------------------*\
| Buckler Accelerator chip functions                      |
|                                                         |
| The main units is in another .PDE file                  |
\*-------------------------------------------------------*/

#define VOK "Accel 0.1 "    // Startup signature


// Pin definitions
const byte ADXL_PIN_SS=5 ;   /// Chip Select for Accelerometer
// SPI interface hardware in the chip uses pins 13, 12, 11, 10
// (10 is set to OUTPUT and has to remain OUTPUT, and is then a normal output pin)

// Accelerometer Registers - and bit patterns
const byte ADXL_REG_DEV_ID=0x00 ;    // Register: Device ident
const byte ADXL_REG_PWR_CTL=0x2D ;   // Register: Power Ctl
const byte   ADXL_VAL_PWR_ON=0x08 ;  //   Value : No Link, No Sleep, Measure On
const byte ADXL_REG_BW_RATE=0x2C ;   // Register : Bandwidth
const byte   ADXL_VAL_BW_25HZ=0x08 ; //   Value : Full power, 25 Hz
const byte ADXL_REG_DATFMT=0x31 ;    // Register : Data Format
const byte   ADXL_VAL_DAT_NRM=0x08 ; //   Value : NoTest, 4wireSPI, FullRange, +-2g
const byte ADXL_REG_XLOW=0x32;       // Register: Xlow
                                     //  next XHigh, YLow, YHigh, ZLow, ZHigh
/* =========\\
|| Setup    ||
\\ =========*/
/*--------------------------------------------------------*\
| setup_accel : Do the necessary setup                     |
|  Assumes Serial and SPI is initialised.                  |
|*--------------------------------------------------------*|
| setup_accel_deselect: pre-initialisation                 |
\*--------------------------------------------------------*/
void setup_accel() {
  // set chip to simple slow sampling
  pinMode(ADXL_PIN_SS, OUTPUT);    // Chip Select
  digitalWrite(ADXL_PIN_SS,HIGH);  // inverted logic, so HIGH is unselected
  accel_write(ADXL_REG_PWR_CTL, ADXL_VAL_PWR_ON);
  accel_write(ADXL_REG_BW_RATE, ADXL_VAL_BW_25HZ);
  accel_write(ADXL_REG_DATFMT, ADXL_VAL_DAT_NRM) ;
  Serial.print(VOK) ;
}

void setup_accel_deselect() { // Must set all spi devices to Deselect first
  pinMode(ADXL_PIN_SS, OUTPUT);    // Chip Select
  digitalWrite(ADXL_PIN_SS,HIGH);  // inverted logic, so HIGH is unselected
}

/* ============================\\
|| IO to/from accelerator chip ||
\\ ============================*/

/*--------------------------------------------------------*\
| accel_read : Read a single register from chip            |
\*--------------------------------------------------------*/
byte accel_read(byte Reg) {
// Read a single register
  byte Val ;
  digitalWrite(ADXL_PIN_SS, LOW);               // Chip select (inverted logic)
  // Clear two top bits, set Read bit
  SPI.transfer((Reg & B00111111) | B10000000);  //send register with READ
  Val = SPI.transfer(B10000000);                // DO the Read
  digitalWrite(ADXL_PIN_SS, HIGH);              // Chip deselect
  return Val ;
}

/*--------------------------------------------------------*\
| accel_write : Write to a single register on chip         |
\*--------------------------------------------------------*/
void accel_write(byte Reg, byte Val) {
// Write to a single register
  digitalWrite(ADXL_PIN_SS, LOW);               // Chip select (inverted logic)
  // Clear two top bits, inclusive Read bit
  SPI.transfer((Reg & B00111111));              // send register with WRITE
  SPI.transfer(Val);                            // send value
  digitalWrite(ADXL_PIN_SS, HIGH);              // Chip deselect
}

/*--------------------------------------------------------*\
| accel_read_xyz : read 16 bits for all 3 axis         |
\*--------------------------------------------------------*/

void accel_read_xyz(byte xyz[6]) {
// Read the 6 data registers in one burst
  digitalWrite(ADXL_PIN_SS, LOW);               // Chip select (inverted logic)
  // Xlow register, set Read bit and Multi bit
  SPI.transfer(ADXL_REG_XLOW | B11000000);      // send DataX0 register, with MultiRead
  for (int i=0; i<6; i++)
    xyz[i] = SPI.transfer(B11000000);           // DO the Read, 6 times
  digitalWrite(ADXL_PIN_SS, HIGH);              // Chip deselect
}

