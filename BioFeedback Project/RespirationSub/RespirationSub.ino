//INITIALIZE THE LED PINES
int led_pin_1 = 7;   
int led_pin_2 = 8;
//INITIALIZE THE SUBMARINE CONTROL PINS
int up_control = 2; 
int dn_control = 4;
//INITIALIZE THE SENSOR INPUT PIN
int sensor = A1;
//INITIALIZE VARIABLE VALUES
float older_value = 0;
float old_value = 0;
float new_value = 0;

void setup() 
{
  //INITIALIZE PIN MODE (INPUT/OUTPUT)
  Serial.begin(600);
  pinMode(led_pin_1, OUTPUT);
  pinMode(led_pin_2, OUTPUT);
  pinMode(up_control, OUTPUT);
  pinMode(dn_control, OUTPUT);
}

void loop() {
  //REPLACE VARIABLE VALUES WITH EACH LOOP ITERATION
  older_value = old_value;
  old_value = new_value;
  new_value = analogRead(sensor);
  Serial.println(analogRead(sensor));

  //IF NEW VALUE < OLD VALUE (INHALE), THE SUBMARINE RISES
  if ((new_value < old_value-1) && (new_value < older_value-1)) { 
        digitalWrite(up_control, HIGH);
        digitalWrite(dn_control, LOW);
        digitalWrite(led_pin_1, HIGH);
        digitalWrite(led_pin_2, LOW);
  }
  //IF NEW VALUE > OLD VALUE (EXHALE), THE SUBMARINE SINKS      
  else if ((new_value > old_value+1) && (new_value > older_value+1)) {
        digitalWrite(up_control, LOW);
        digitalWrite(dn_control, HIGH);
        digitalWrite(led_pin_1, LOW);
        digitalWrite(led_pin_2, HIGH);
  }
}
