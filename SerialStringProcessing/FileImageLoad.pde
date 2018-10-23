import at.mukprojects.imageloader.*;
import at.mukprojects.imageloader.file.*;
import at.mukprojects.imageloader.image.*;
import java.util.Date;
File file;
String path = "/Users/jungu/Downloads/SkyLight/_photoskycollection";
String userpath = "/Users/jungu/Downloads/SkyLight/nodeuploads/public/uploads";
ImageLoader loader;
ImageList list;
Image loadedImg;

ImageList userlist;
Image userloadedImg;
int lastSize = 1;


void keyPressed(){
  if (key == 'b' || key == 'B') {
    loadedImg = userlist.getMostRecentImage();
  }
  if(key == TAB){
    collectionPicMode = true;
  }
  if(keyCode == LEFT || keyCode == RIGHT||keyCode == UP||keyCode == DOWN){
  loadedImg = list.getRandom();
  }
}

boolean CheckNewUserImage(){
   file = new File(userpath);
  int newSize = file.listFiles().length;
  
  boolean flag = lastSize==newSize?false:true;
  if(flag){
  println(flag);
  userlist = loader.start(userpath);
  delay(5000);
}
  lastSize = newSize;
  return flag;
}
