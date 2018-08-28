import processing.video.*; 

Capture cam; 

color blue  = color(0, 0, 255); 
color green = color(0, 255, 0); 
color red   = color(255, 0, 0); 
color c; 
int alpha = 255; 
int g2; 
int b2;
int r2;
int count = 0; 
int y = 0; 
int x = 0; 

void setup() { 
  size(640, 480); 
  cam = new Capture(this);
  cam.start(); 
} 

void draw() { 
  if (cam.available()) { 
    // Reads the new frame
    cam.read(); 
    count++; 
  } 
  image(cam, 0, 0); 
  loadPixels(); 
  // Skip top and bottom edges
  for (y = 1; y < cam.height-1; y++) { 
    // Skip left and right edges
    for (x = 1; x < cam.width-1; x++) { 
      c = pixels[y*cam.width+x]; //get(x, y); 
      // get the blue value 
      //float b1 = blue(c); 
      b2 = int(c & 0xFF); // better 
      // get the green value 
      //float g1 = green(c);
      g2 = int(c >> 8 & 0xFF); // better 
      // get the red value 
      //float r1 = red(c);  
      r2 = int(c >> 16 & 0xFF);  // better 
      if ( b2 > 200 && g2 < 200 && r2 < 150 ) {
        pixels[y*cam.width+x] = green;
      } else {
        pixels[y*cam.width+x] = //(alpha << 24) | 
                                (r2    << 16) |
                                (g2    << 8)  | b2; 
      }
    }
  }
  
  c = pixels[mouseY*cam.width+mouseX];
  fill(c); 
  noStroke(); 
  rect(0, 0, 25, 25); 
  
  updatePixels(); 
  if (count >= 1) { 
    //noLoop(); 
  } 
}

void mouseClicked() {
  //loop(); 
  color m =  pixels[mouseY*cam.width+mouseX];
  print(int(m >> 16 & 0xFF)); 
  print(" "); 
  print(int(m >> 8 & 0xFF)); 
  print(" "); 
  println(int(m & 0xFF)); 
}

