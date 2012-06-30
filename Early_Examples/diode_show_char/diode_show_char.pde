/// Extended to show input typed at Serial

#define DIODE_CLOCKOUTPIN 7
#define DIODE_CLOCKPIN 6
#define DIODE_OUTPUTPIN 5

#define DIODE_CLOCKOUTPIN 9
#define DIODE_CLOCKPIN 10
#define DIODE_OUTPUTPIN 8
#define DIODE_OUTPUTENABLEPIN 7

#define RED 0
#define GREEN 1
#define YELLOW 2

char small_font[26][8] = {
  {0x00,0x7c,0x44,0x44,0x7c,0x44,0x00,0x00},
  {0x00,0x7c,0x44,0x78,0x44,0x7c,0x00,0x00},  
  {0x00,0x7c,0x40,0x40,0x40,0x7c,0x00,0x00},  
  {0x00,0x78,0x44,0x44,0x44,0x78,0x00,0x00},  
  {0x00,0x7c,0x40,0x78,0x40,0x7c,0x00,0x00},
  {0x00,0x7c,0x40,0x70,0x40,0x40,0x00,0x00},
  {0x00,0x7c,0x40,0x4c,0x44,0x7c,0x00,0x00},
  {0x00,0x44,0x44,0x7c,0x44,0x44,0x00,0x00},
  {0x00,0x7c,0x10,0x10,0x10,0x7c,0x00,0x00},
  {0x00,0x0c,0x04,0x04,0x44,0x7c,0x00,0x00},
  {0x00,0x44,0x48,0x70,0x48,0x44,0x00,0x00},
  {0x00,0x40,0x40,0x40,0x40,0x7c,0x00,0x00},
  {0x00,0x44,0x6c,0x54,0x44,0x44,0x00,0x00},
  {0x00,0x44,0x64,0x54,0x4c,0x44,0x00,0x00},
  {0x00,0x38,0x44,0x44,0x44,0x38,0x00,0x00},  
  {0x00,0x78,0x44,0x78,0x40,0x40,0x00,0x00},		  
  {0x00,0x7c,0x44,0x44,0x7c,0x10,0x00,0x00},
  {0x00,0x78,0x44,0x78,0x44,0x44,0x00,0x00},
  {0x00,0x7c,0x40,0x7c,0x04,0x7c,0x00,0x00},
  {0x00,0x7c,0x10,0x10,0x10,0x10,0x00,0x00},		  
  {0x00,0x44,0x44,0x44,0x44,0x7c,0x00,0x00},
  {0x00,0x44,0x44,0x28,0x28,0x10,0x00,0x00},
  {0x00,0x44,0x44,0x54,0x54,0x28,0x00,0x00},
  {0x00,0x44,0x28,0x10,0x28,0x44,0x00,0x00},
  {0x00,0x44,0x44,0x28,0x10,0x10,0x00,0x00},
  {0x00,0x7c,0x08,0x10,0x20,0x7c,0x00,0x00}
};
  
char whitespace[8] = {0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0};

char small_square[8] = {0x0,0x0,0x0,0x18,0x18,0x0,0x0,0x0};



void diode_init() {
  
  pinMode(DIODE_CLOCKOUTPIN,OUTPUT);
  pinMode(DIODE_CLOCKPIN,OUTPUT);
  pinMode(DIODE_OUTPUTPIN,OUTPUT);
  pinMode(DIODE_OUTPUTENABLEPIN,OUTPUT);
  
  digitalWrite(DIODE_OUTPUTENABLEPIN, HIGH); // disable output
  
  diode_clear();
}



void diode_print_bitmap(char lines[], int color) {
  
  int i;
  int col;
  int row;
  int offset_row;
  int offset_col;
  
  digitalWrite(DIODE_OUTPUTENABLEPIN, LOW); // enable output
  
  for(col = 0; col < 8; col++) {
    
    digitalWrite(DIODE_CLOCKOUTPIN, LOW);  

    for(i = 0; i < 24; i++) {
      
      if(i == col) {

       digitalWrite(DIODE_OUTPUTPIN, HIGH);
       
      } else if(i >= 8) {
        
        if(i >= 16) {
          
          if(color == RED) {  
            digitalWrite(DIODE_OUTPUTPIN, LOW);
            goto clock;
          }
          
          row = 7 - (i - 16); // green diode connections are inverted
        } else {
          
          if(color == GREEN) {  
            digitalWrite(DIODE_OUTPUTPIN, LOW);
            goto clock;
          }        
          row = i - 8;
        }
        
        offset_row = row;
        if((offset_row > 7) || (offset_row < 0)) {
          digitalWrite(DIODE_OUTPUTPIN, LOW);
          goto clock;
        }
        
        
        offset_col = col;
        if((offset_col > 7) || (offset_col < 0)) {
          digitalWrite(DIODE_OUTPUTPIN, LOW);
          goto clock; 
        }
        
        if(lines[offset_row] & (1 << (8 - offset_col))) {

          digitalWrite(DIODE_OUTPUTPIN, HIGH);
          
        } else {
          digitalWrite(DIODE_OUTPUTPIN, LOW);       
        }
        
      } else {
        digitalWrite(DIODE_OUTPUTPIN, LOW);
      }
    
      clock:
        digitalWrite(DIODE_CLOCKPIN, HIGH);
        digitalWrite(DIODE_CLOCKPIN, LOW); 

    }
    
    digitalWrite(DIODE_CLOCKOUTPIN, HIGH); 

  }
  
  digitalWrite(DIODE_OUTPUTENABLEPIN, HIGH); // disable output
  
}

int diode_print_char(char c, int color) {

  if(c == ' ') {
    diode_print_bitmap(whitespace, color);
    return 0; 
  }
  
  if((c < 'A') || (c > 'Z')) {
    return -1;
  } else {
    
    diode_print_bitmap(small_font[c - 'A'], color);
  }
 
  return 0;
}


void diode_clear() {
 
  diode_print_char(' ', RED);

}


void setup() {

  diode_init();
  diode_clear();
  
  Serial.begin(9600);
    
  delay(1000);
}


void loop() {
  static char C ;
  static byte Col ;
  static unsigned long Tmr ;
  if ( millis() - Tmr > 800UL && Serial.available() > 0) {
    C = Serial.read() ;
    Tmr = millis() ;
    if ( 'a' <= C && C <= 'z' ) {
      Col = YELLOW ;
      C = C - 'a' + 'A' ;
    } else Col = GREEN ;
  }
  if ( millis() - Tmr > 800UL && Serial.available() == 0 )
    C = ' ' ;
  diode_print_char( C, Col );
  //delay(3);

}

