// Arduino Code - Bulletproof One-Shot
const int btnStart = 2; 
const int btnPlus  = 3; 
const int btnMinus = 4; 

int lastStart = HIGH;
int lastPlus  = HIGH;
int lastMinus = HIGH;

void setup() {
  Serial.begin(9600);
  pinMode(btnStart, INPUT_PULLUP);
  pinMode(btnPlus,  INPUT_PULLUP);
  pinMode(btnMinus, INPUT_PULLUP);
}

void loop() {
  // Use a helper function to keep the loop clean
  checkButton(btnStart, lastStart, 's');
  checkButton(btnPlus,  lastPlus,  'p');
  checkButton(btnMinus, lastMinus, 'm');
}

void checkButton(int pin, int &lastState, char cmd) {
  int currentState = digitalRead(pin);

  // TRIGGER CONDITION: 
  // It must be LOW now (pressed) AND it must have been HIGH before (released).
  if (currentState == LOW && lastState == HIGH) {
    Serial.print(cmd);
    
    // DEBOUNCE: 
    // This 'delay' is the secret sauce. It tells the Arduino to "blind" itself 
    // to the button's vibrations for 150ms. This covers both the press bounce 
    // and the release bounce.
    delay(150); 
  }

  // Only update the lastState when the button is actually stable
  lastState = currentState;
}
