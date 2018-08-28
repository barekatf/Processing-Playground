// Graphing sketch

import processing.serial.*;
PFont f; 
Serial port;
int val; // Data received from the serial port
int[] values;
float zoom;
int max = 0; 
int lastMax = 0; 
int totalMax = 0; 

void setup () {
  size(1100, 500);
  println(Serial.list()); 
  //port = new Serial(this, Serial.list()[0], 57600);
  port = new Serial(this, "//dev//tty.usbmodem411", 57600);
  values = new int[width];
  zoom = 1.0f;
  smooth();

  f = createFont("Arial", 16, true);
  textSize(30); 
  textFont(f); 
  port.clear();
}

void draw()
{
  background(0);
  drawGrid();
  drawLastMax(); 
  val = getValue();
  if (val != -1) {
    pushValue(val);
  }
  writeValue(val); 
  valueFollower(val); 
  writeMax(val);
  drawLines();
}

int getY(int val) {
  return (int)(height - val / 1023.0f * (height - 1));
}

int getValue() {
  int value = -1;
  while (port.available () >= 3) {
    if (port.read() == 0xff) {
      value = (port.read() << 8) | (port.read());
    }
  }
  return value;
}

void pushValue(int value) {
  for (int i=0; i<width-1; i++)
    values[i] = values[i+1];
  values[width-1] = value;
}

void drawLines() {
  stroke(255);

  int displayWidth = (int) (width / zoom);

  int k = values.length - displayWidth;

  int x0 = 0;
  int y0 = getY(values[k]);
  for (int i=1; i<displayWidth; i++) {
    k++;
    int x1 = (int) (i * (width-1) / (displayWidth-1));
    int y1 = getY(values[k]);
    line(x0, y0, x1, y1);
    x0 = x1;
    y0 = y1;
  }
}

void writeValue(int value) { 
  text("Real Time:", 15, 30);
  text(value, 100, 30);
}

void valueFollower(int value) { 
  stroke(255, 0, 0); 
  line(150, getY(value), width, getY(value));
}

void writeMax(int value) { 
  text("Maximum:", 15, 60); 
  if (max < value) { 
    max = value;
  }
  text(max, 100, 60);
  if (totalMax < value) {
    totalMax = value; 
  }
  text("Winner Maximum:", 15, height-30); 
  text(totalMax, 150, height-30); 
}

void drawLastMax() { 
  stroke(0, 0, 255); 
  line(150, getY(lastMax), width, getY(lastMax));
}

void drawGrid() {
  stroke(0, 255, 0);
  line(0, height/2, width, height/2); // horizontal 
  line(width/2, 0, width/2, height); // vertical 
  line((width/2)-20, (height/8), (width/2)+20, (height/8)); 
  line((width/2)-20, 2*(height/8), (width/2)+20, 2*(height/8)); 
  line((width/2)-20, 3*(height/8), (width/2)+20, 3*(height/8)); 
  line((width/2)-20, 5*(height/8), (width/2)+20, 5*(height/8)); 
  line((width/2)-20, 6*(height/8), (width/2)+20, 6*(height/8)); 
  line((width/2)-20, 7*(height/8), (width/2)+20, 7*(height/8)); 
}

void keyReleased() {
  switch (key) {
  case '+':
    zoom *= 2.0f;
    println(zoom);
    if ( (int) (width / zoom) <= 1 )
      zoom /= 2.0f;
    break;
  case '-':
    zoom /= 2.0f;
    if (zoom < 1.0f)
      zoom *= 2.0f;
    break;
  case 'r': 
    lastMax = max; 
    max = 0; 
    break;
  }
}

int[] receiveInteger(String DataIn) {
  int _chars = 0; 
  String _subData = null; 
  //get rid of new line character on each line
  _chars = DataIn.length(); 
  _subData = DataIn.substring(0, _chars-2);
  int[] val = int(splitTokens(_subData)); 
  return val;
}

