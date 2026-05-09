// Arduino Code - Added Variation Button on Pin 5
const int btnStart = 2;
const int btnPlus  = 3;
const int btnMinus = 4;
const int btnVar   = 5; // New button for Track 5 Variation

int lastStart = HIGH;
int lastPlus  = HIGH;
int lastMinus = HIGH;
int lastVar   = HIGH; // Memory for Pin 5

void setup() {
  Serial.begin(9600);
  pinMode(btnStart, INPUT_PULLUP);
  pinMode(btnPlus,  INPUT_PULLUP);
  pinMode(btnMinus, INPUT_PULLUP);
  pinMode(btnVar,   INPUT_PULLUP); // Initialize Pin 5
}

void loop() {
  checkButton(btnStart, lastStart, 's');
  checkButton(btnPlus,  lastPlus,  'p');
  checkButton(btnMinus, lastMinus, 'm');
  checkButton(btnVar,   lastVar,   'v'); // Check Pin 5
}

void checkButton(int pin, int &lastState, char cmd) {
  int currentState = digitalRead(pin);
  if (currentState == LOW && lastState == HIGH) {
    Serial.print(cmd);
    delay(150); 
  }
  lastState = currentState;
}
