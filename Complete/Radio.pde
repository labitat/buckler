/*-------------------------------------------------------*\
| Buckler Radio chip functions                            |
|                                                         |
| The main units is in another .PDE file                  |
\*-------------------------------------------------------*/

#define VOK "Radio 0.01 "

// Pin definitions
// SPI interface hardware in the chip uses pins 13, 12, 11, 10
// (10 is set to OUTPUT and has to remain OUTPUT, and is then a normal output pin)
const byte NRF_PIN_SS=2 ;          // Chip Select for Radio chip

//const byte NRF_PIN_CE=4 ;          // radio Chip direction?
//const byte NRF_PIN_IRQ=3 ;       // ?

// Chip registers
const byte NRF_REG_CONF=0x00 ;    // Config Register
const byte NRF_VAL_CONF_PWR_UP=0x01 ; // 1=PowerUP, else Down
const byte NRF_REG_EN_AA=0x01 ;   // Enable Auto Ack on pipes
const byte NRF_REG_EN_RXADR=0x02 ;// Enabled RX address
const byte NRF_REG_STAT=0x07 ;    // Status (write to clear bit)
const byte NRF_VAL_STAT_RXDR=0x40 ;   //  RX data ready
const byte NRF_VAL_STAT_TXDS=0x20 ;   //  TX being sent

/* =========\\
|| Setup    ||
\\ =========*/

/*--------------------------------------------------------*\
| setup_radio : Do the necessary setup                     |
|  Assumes Serial and SPI is initialised.                  |
|*--------------------------------------------------------*|
| setup_radio_deselect: pre-initialisation                 |
\*--------------------------------------------------------*/
void setup_radio() {
  // radio_write(NRF_REG_CONF, RegVal|NRF_VAL_CONF_PWR_UP);
  Serial.print(VOK) ;
}

void setup_radio_deselect() {
  // Must set all spi devices to Deselect first
  pinMode(NRF_PIN_SS, OUTPUT);    // Chip Select
  digitalWrite(NRF_PIN_SS,HIGH);  // inverted logic, so HIGH is unselected
}

/* ======================\\
|| IO to/from radio chip ||
\\ ======================*/
