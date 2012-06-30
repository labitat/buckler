/// Edited to fit new SPI library (Arduino IDE 1.0.1)
///  and better Serial output
/// LED stuff removed - this is ONLY the accelerator


#include <SPI.h>   /// Include SPI library, define "SPI" as instance of class

#define VOK "OK 0.1"  /// Startup message

// Accelerometer
#define ADXL_MASK_CLEAR 0x3F // 0011 1111 for clearing first two bits (before masks are set)
#define ADXL_READ_MASK 0x80 // 1000 0000 first bit set for read
#define ADXL_WRITE_MASK 0x00 // 0000 0000 first bit unset for write
#define ADXL_MB_MASK 0x40 // 0100 0000 second bit set for multi-byte operation
#define ADXL_REG_DEV_ID 0x0

#define ADXL_REG_POWER_CTL 0x2D
#define ADXL_REG_POWER_CTL_POWER_ON 0x08 // 0000 1000 power it up!

#define ADXL_REG_DATA_FORMAT 0x31
#define ADXL_REG_DATA_FORMAT_FULL_RES_FULL_RANGE 0x03 // 10 bit mode, full range

#define ADXL_REG_BW_RATE 0x2C
#define ADXL_REG_BW_RATE_100HZ 0x0A // 1010 output data rate of 100 Hz

#define ADXL_REG_FIFO_CTL 0x38
#define ADXL_REG_FIFO_CTL_CLEAR 0x0 // clear fifo
#define ADXL_REG_FIFO_CTL_FIFO_STREAM 0x9F // 1000 0000 stream mode, no watermark

#define ADXL_REG_FIFO_STATUS 0x39

#define ADXL_DO_READ 0
#define ADXL_DO_WRITE 1

#define ADXL_PIN_SS 5   /// Chip Select for Accelerometer
#define NRF_PIN_SS 2    /// Chip select for Radio(?)


void init_spi_pins() {
  
  pinMode(NRF_PIN_SS, OUTPUT);
  pinMode(ADXL_PIN_SS, OUTPUT);
  
  digitalWrite(ADXL_PIN_SS,HIGH);
  digitalWrite(NRF_PIN_SS,HIGH);
  
}

void accel_init_spi() {
  SPI.begin() ;  /// Added startup
  SPI.setDataMode((1 << SPE) | (1 << CPOL) | (1 << CPHA) | (0 << DORD) | (1 << MSTR) | (0 << SPR0) | (0 << SPR1));
  
}

// read or write an accelerometer register
int accel_rw_reg(byte reg, byte* data, int num_bytes, byte r_or_w, byte* output) {

    int i;
    byte mb_mask = 0x0;
    byte rw_mask = (r_or_w == ADXL_DO_READ) ? ADXL_READ_MASK : ADXL_WRITE_MASK;
  
    if(num_bytes < 1) {
      return -1;
    } else if(num_bytes > 1) {
      if(!output) {
        return -2;
      }
      mb_mask = ADXL_MB_MASK; // multi byte mask
    }
    
    digitalWrite(ADXL_PIN_SS,LOW);
    
    SPI.transfer((reg & ADXL_MASK_CLEAR) | rw_mask | mb_mask );
    
    for(i = 0; i < num_bytes; i++) {

      if(r_or_w == ADXL_DO_READ) {
        output[i] = SPI.transfer(ADXL_READ_MASK);
      } else {
        SPI.transfer(data[i]); 
      }
      
    }
 
    digitalWrite(ADXL_PIN_SS,HIGH); 

    return 0;
  
}

byte accel_read(byte reg) {
  byte output;
  int ret;
  
  ret = accel_rw_reg(reg, NULL, 1, ADXL_DO_READ, &output);
  
  
  if(ret < 0) {
    Serial.println("Error!");
    Serial.print(ret, DEC);
    delay(1000);
    return 0;
  }
  
  return output;
  
}

void accel_write(byte reg, byte data) {
  int ret;
  
  ret = accel_rw_reg(reg, &data, 1, ADXL_DO_WRITE, NULL);
  
  if(ret < 0) {
    Serial.println("Error!");
    Serial.print(ret, DEC);
    delay(1000);
    return;
  }
  
}


void accel_init() {
  accel_init_spi();

  delay(10);
  
  accel_write(ADXL_REG_POWER_CTL, ADXL_REG_POWER_CTL_POWER_ON);
  accel_write(ADXL_REG_DATA_FORMAT, ADXL_REG_DATA_FORMAT_FULL_RES_FULL_RANGE);
  accel_write(ADXL_REG_BW_RATE, ADXL_REG_BW_RATE_100HZ);
  accel_write(ADXL_REG_FIFO_CTL, ADXL_REG_FIFO_CTL_CLEAR);
  accel_write(ADXL_REG_FIFO_CTL, ADXL_REG_FIFO_CTL_FIFO_STREAM);

}

void accel_print_id() {
  
  byte output;

  output = accel_read(ADXL_REG_DEV_ID);

  Serial.print("Device ID: ");
  Serial.print(output, BIN);
  Serial.print(" ");
  Serial.println(output, HEX);
  
}

void setup() {
  init_spi_pins();
  accel_init();
  
  Serial.begin(9600);
  Serial.println(VOK) ; /// startup message
  delay(1000);
}


void loop() {

  accel_print_id();
  delay(1000);
  
}


