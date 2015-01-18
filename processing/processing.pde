import processing.serial.*;

Serial myPort;        // The serial port

void setup () {
  // set the window size:
  size(800, 600);        

  // List all the available serial ports
  // if using Processing 2.1 or later, use Serial.printArray()
  //println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 115200);

  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');

  // set inital background:
  background(0);
  text("V: ", 700, 500);
}

int rectX = 1, rectY = 1, rectW = 30, rectH = 10;
boolean start = false;

void draw () {
  update();

  stroke(255);
  fill(0);
  rect(rectX, rectY, rectW, rectH);

  fill(255);
  if (start) {
    text(" hold", rectX, rectY + rectH);
  } else {
    text(" run", rectX, rectY + rectH);
  }
}

boolean buttonOver = false;

void mousePressed() {
  if (buttonOver) {
    start = !start;
    if (start) {
      myPort.write("START");
    } else {
      myPort.write("STOP");
    }
  }
}

void update() {
  if ( overRect(rectX, rectY, rectW, rectH) ) {
    buttonOver = true;
  } else {
    buttonOver = false;
  }
}

boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

int xPos = 1, yPos = 0;
float volt = 0;

void refresh() {
  stroke(255);
  point(xPos, height - yPos);

  fill(0);
  stroke(0);
  rect(710, 500 - 10, 10 * 6, 10);

  fill(255);
  text(volt, 710, 500);
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    // convert to an int and map to the screen height:
    yPos = (int)map(float(inString), 0, 1023, height / 3, 2 * height / 3);
    volt = map(float(inString), 0, 1023, 0, 5);  // in mV

    // at the edge of the screen, go back to the beginning:
    if (xPos >= width) {
      xPos = 0;
      background(0);
      text("V: ", 700, 500);
    } else {
      // increment the horizontal position:
      xPos++;
    }

    refresh();
  }
}

