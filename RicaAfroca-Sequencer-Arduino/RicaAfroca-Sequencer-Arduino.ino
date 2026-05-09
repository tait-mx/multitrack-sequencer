// Arduino Code
const int btnStart = 2;
const int btnPlus = 3;
const int btnMinus = 4;

void setup() {
  Serial.begin(9600);
  pinMode(btnStart, INPUT_PULLUP);
  pinMode(btnPlus, INPUT_PULLUP);
  pinMode(btnMinus, INPUT_PULLUP);
}

void loop() {
  // We send a character only on the transition from HIGH to LOW (press)
  if (digitalRead(btnStart) == HIGH) { Serial.print('s'); delay(200); }
  if (digitalRead(btnPlus) == HIGH)  { Serial.print('p'); delay(200); }
  if (digitalRead(btnMinus) == HIGH) { Serial.print('m'); delay(200); }
}
