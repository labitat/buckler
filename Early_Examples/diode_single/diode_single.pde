// Accelerometer

#define DIODE_CLOCKOUTPIN 9
#define DIODE_CLOCKPIN 10
#define DIODE_OUTPUTPIN 8
#define DIODE_OUTPUTENABLEPIN 7


void diode_init() {
  
  pinMode(DIODE_CLOCKOUTPIN,OUTPUT);
  pinMode(DIODE_CLOCKPIN,OUTPUT);
  pinMode(DIODE_OUTPUTPIN,OUTPUT);
  pinMode(DIODE_OUTPUTENABLEPIN,OUTPUT);
  
  digitalWrite(DIODE_OUTPUTENABLEPIN, HIGH); // disable output
  
}


void diode_enable_single() {
  
  int i;
  
  digitalWrite(DIODE_OUTPUTENABLEPIN, LOW); // enable output
  
  digitalWrite(DIODE_CLOCKOUTPIN, LOW);
  
  for(i = 0; i < 24; i++) {
    if((i == 4) || (i == 12)) {
      digitalWrite(DIODE_OUTPUTPIN, HIGH);
    } else {
      digitalWrite(DIODE_OUTPUTPIN, LOW);
    }
    digitalWrite(DIODE_CLOCKPIN, HIGH);
    digitalWrite(DIODE_CLOCKPIN, LOW);    
  }

  digitalWrite(DIODE_CLOCKOUTPIN, HIGH);
  digitalWrite(DIODE_CLOCKOUTPIN, LOW);
  digitalWrite(DIODE_OUTPUTENABLEPIN, LOW); // disable output

}  


void setup() {

  diode_init();
  
  Serial.begin(9600);
    
  delay(1000);
}


void loop() {

  diode_enable_single();
  delay(3);

}


