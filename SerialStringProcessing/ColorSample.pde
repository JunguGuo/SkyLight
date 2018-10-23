color[] SampleColor(int sampleNum, PImage img, boolean useStrip) {
  color[] colors = new color[sampleNum]; 

  if (!useStrip || begin ==null ||end ==null) {
    //defualt way to sample
    int padding = 10;
    int validHeight = img.height - padding*2;
    int step = validHeight/(sampleNum-1);

    for (int i = 0; i<sampleNum; i++) 
      colors[i] = img.get(img.width/2, padding+i*step);
  } else if (useStrip) {
    //use custom strip to sample
    float step = 1.0/(sampleNum - 1);
    for (int i = 0; i<sampleNum; i++) {
      PVector v = PVector.lerp(begin, end, i*step);
      colors[i] = img.get((int)v.x, (int)v.y);
    }
  }

  for (int i = 0; i<colors.length; i++)
    colors[i] = filterColor(colors[i]);
  return colors;
}

String Colors2String(color[] colors) {
  String s = "";
  for (color c : colors) {
    int r = int(c >> 16 & 0xFF);
    s +=str(r);
    s+=":";
    int g = int(c >> 8 & 0xFF);
    s +=str(g);
    s+=":";
    int b = int(c & 0xFF);  
    s +=str(b);
    s+=":";
  }
  s+='\n';
  return s;
}

void showDebugColors(color[] colors) {
  //debug show cols
  if (colors ==null)
    return;
  for (int i =0; i<colors.length; i++) {
    fill(colors[i]);
    rectMode(CENTER);
    float size = height/resolution;
    rect(0, i*size+size/2, size, size);
  }
}

color filterColor(color c) {
  colorMode(HSB, 255);
  float b = brightness(c)*0.75;
  float s = saturation(c)*1.7;
  c = color(hue(c), s, b);
  colorMode(RGB, 255);
  return c;
}
