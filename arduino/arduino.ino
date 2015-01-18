
void setup() {
  // initialize the serial communication:
  Serial.begin(115200);
}

#define START 1
#define STOP 0

byte mode = STOP;

void loop() {
  if (Serial.available() > 0) {
    char cmd[8] = {0};
    Serial.readBytesUntil('\n', cmd, sizeof(cmd));
    if (String(cmd) == "START") {
      mode = START;
    }
    if (String(cmd) == "STOP") {
      mode = STOP;    
    }
  }
  if (mode == START) {
    // send the value of analog input 0:
    Serial.println(analogRead(A0));
  }
}

