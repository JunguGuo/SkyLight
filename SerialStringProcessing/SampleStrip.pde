PVector begin;
PVector end = new PVector(0, 0);
boolean isInit = true;

void mouseDragged() 
{
  if (isInit) {
    begin = new PVector(mouseX, mouseY); 
    end = begin.copy();
    isInit = false;
  } else {
    end = new PVector(mouseX, mouseY);
  }
}

void mouseReleased(){
  isInit = true;
}

void showSampleStrip() {
  if (begin ==null || end == null)
    return;
  strokeCap(ROUND);
  strokeWeight(2);
  stroke(0);
  line(begin.x, begin.y, end.x, end.y);
}
