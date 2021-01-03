/*
You must press a Random Key, to kill the Circle on the Random position
 All Letters will be in a string[] and it will choose a random Number and picks this.
 The Circle gets the Key that must pressed.
 It will check Online for Updates
 */
import processing.sound.*;
import processing.serial.*;
//import processing.video.*;  

//Create XML from Website
XML xml;
PImage loadScreen;
String version="Beta 0.2";
String developerVersion="Beta 0.2";
String newestVersion=null;
String newestDeveloperVersion = null;
String changeLog = null;
String additional = null;
String downloadSite = "https://flossingame.glitch.me";
Boolean playMusic = true;
Boolean developerFunctions = false;
//Letters = the next Letters, MAX 100 && characters all the characters to use.
private String[] characters = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"};
String[] letters = new String[100];
//If Inf = 0, game is running, Inf=1, game is paused. (Not boolean because I can add other things too (Maybe Help Screen!)
int inf = 1;
int time;
int wait = 5000;
int process = 0;
int pressKey = 0;
int pressMouse = 0;
int highScore = 0;
int score = 0;
int[] position = new int[2];
String[] save = new String[10];
String[] load = new String[10];
String[] lines;
String temp = "5000";
boolean startup = true;
SoundFile lose;
SoundFile music;

void settings() {
  size(1000, 1000);
}

void setup() {
  textAlign(CENTER, CENTER);
  ellipseMode(CENTER);
  imageMode(CENTER);
  textSize((height+width)/100);
  background(0);
  fill(255);
  loadScreen = loadImage("Load.jpg");
  image(loadScreen, width/2, height/2);
  lines = loadStrings("gameInfo.app");
  save = lines;
  try {
    saveStrings("gameInfo.app", save);
  }
  catch(NullPointerException n) {
    try {
      File myObj = new File("gameInfo.app");
      if (myObj.createNewFile()) {
        try {
          saveStrings("gameInfo.app", save);
        }
        catch(NullPointerException f) {
          save[0] = version;
          save[1] = "0";
          save[2] = null;
          save[3] = null;
          save[4] = null;
          save[5] = null;
          save[6] = null;
          save[7] = null;
          save[8] = null;
          save[9] = null;
          saveStrings("gameInfo.app", save);
        }
      } else {
      }
    } 
    catch (IOException e) {
    }
  }
  //Download XML
  xml = loadXML("https://flossingame.glitch.me/Key.xml");
  loadInternetFiles();
  checkVersion();
  noCursor();
  setLetters();
  time = millis();//store the current time
  wait=Integer.parseInt(temp);
  delay(1000);
  position[0] = int(random(50, width-50));
  position[1] = int(random(50, height-50));
  delay(4000);
}

//Load the Content from the Internet
void loadInternetFiles() {
  if (checkConnection()==true) {
    try {
      //Get Content of XML
      XML[] xmlFile = xml.getChildren("id");
      newestVersion = xmlFile[0].getContent();
      changeLog = xmlFile[1].getContent();
      additional = xmlFile[2].getContent();
      downloadSite = xmlFile[3].getContent();
      temp = xmlFile[4].getContent();
      newestDeveloperVersion = xmlFile[5].getContent();
      save[0] = newestVersion;
      save[2] = temp;
    }
    catch (NullPointerException n) {
      newestVersion = "No Internet Connection";
      changeLog = "No Internet Connection, restart the Game, to check again.";
      additional = "No Internet Connection";
    }
    catch (ArrayIndexOutOfBoundsException a) {
    }
  } else {
    newestVersion = "No Internet Connection";
    changeLog = "No Internet Connection, restart the Game, to check again.";
    additional = "No Internet Connection";
  }
  try {
    for (int i = 0; i < lines.length; i++) {
      if (lines[i]!=null) {
        if (i==0) {
          newestVersion=lines[i];
        } else if (i==1) { 
          try {
            highScore=Integer.parseInt(lines[i]);
          }
          catch(NumberFormatException e) {
          }
        } else if (i==2) {
          try {
            wait=Integer.parseInt(lines[i]);
          } 
          catch(NumberFormatException e) {
          }
        } else if (i == 3) {
          developerFunctions = Boolean.parseBoolean(lines[i]);
        } else {
        }
      }
    }
  }
  catch(NullPointerException n) {
    for (int i = 0; i < 10; i++) {
      if (lines[i]!=null) {
        if (i==0) {
          newestVersion=version;
        } else if (i==1) { 
          try {
            highScore=0;
          }
          catch(NumberFormatException e) {
          }
        } else if (i==2) {
          try {
            wait = Integer.parseInt(temp);
          } 
          catch(NumberFormatException e) {
          }
        } else if (i == 3) {
          developerFunctions = false;
        } else {
        }
      }
    }
  }
}

//Check if there is a connection
boolean checkConnection() {
  String internet = null;
  try {
    XML[] xmlFile = xml.getChildren("id");
    internet = xmlFile[0].getContent();
  } 
  catch(NullPointerException n) {
  }
  if (internet == null) {
    return false;
  } else {
    return true;
  }
}

void draw() {
  if (startup==true) {
    delay(1000);
    startup=false;
  }
  background(0);
  fill(255);
  if (process==99) {
    reset();
  }
  if (inf==0) {
    if (millis() - time >= wait) {
      text("You Died :()", width/2, height/2);
      end();
    } else {
      ellipse(position[0], position[1], 100, 100);
      text("Points: "+score+'\n'+"High score: "+highScore, width/2, 50);
      fill(0);
      text("Click: "+'\n'+letters[process], position[0], position[1]);
    }
  }
  //Set the text 
  //TODO: Load Strings from File.csv
  if (inf==1) {
    text("Welcome to my Game "+ "Score: "+score+" Highscore "+highScore+'\n'+"Info: "+'\n'+additional+'\n'+ "Change log: "+'\n'+changeLog, width/2, height/2);
    text("Credits with RIGHT Mouse Click. Restart with LEFT Mouse Click /ENTER. MUTE/UNMUTE with SHIFT", width/2, height-60);
  }
  if (inf==3) {
    text("Credit for Music: "+"Cjbeards - Sandcastle is under a Creative Commons license (CC BY 3.0)"+'\n'+" https://creativecommons.org/licenses/..."+'\n'+" Music promoted by BreakingCopyright: https://youtu.be/DkKSl09pnns", width/2, height/2);
    text("Credits with RIGHT Mouse Click. Restart with LEFT Mouse Click/ENTER. MUTE/UNMUTE with SHIFT", width/2, height-60);
  }
}

//Sets the Letters for the next 100 moves
void setLetters() {
  for (int i= 0; i!=letters.length; i++) {
    letters[i]=characters[int(random(0, characters.length))];
  }
}

//Check the newest version
void checkVersion() {
  if (newestVersion.equals("No Internet Connection") || newestDeveloperVersion.equals(null)) {
  } else if ((!version.equals(newestVersion) || !developerVersion.equals(newestDeveloperVersion))) {
    link(downloadSite);
  }
}

//Reset the positions of the circle
void reset() {
  position[0] = int(random(50, width-50));
  position[1] = int(random(50, height-50));
  process = 0;
  setLetters();
}

//Ater a Game/If key was pressed to load the Data
void retryConnection() {
  if (checkConnection()==true) {
    loadInternetFiles();
  }
}

//Do the things, if some keys was pressed
void checkPressed() {
  if (keyPressed == true) {
    if (key != ';' && key !=letters[process].charAt(0) && inf == 0 && key!='/' && keyCode != ENTER && keyCode != SHIFT) {
      end();
    }
    if (key == letters[process].charAt(0)) {
      position[0] = int(random(50, width-50));
      position[1] = int(random(50, height-50));
      process++;
      score++;
      time = millis();
    }
    if (key=='/') {
      setup();
    }
    if (keyCode==ENTER && inf != 0) {
      time = millis();
      score=0;
      try {
        if (playMusic == true) {
          music.loop();
        }
      }
      catch(NullPointerException n) {
      }
      inf = 0;
    }
    if (keyCode == SHIFT  && pressKey == 255) {
      if (playMusic == true) {
        playMusic = false;
        pressKey = 0;
      } else if (playMusic == false) {
        playMusic = true;
        pressKey = 0;
      }
    }
  }
}

//Do the things, if a mouse key was pressed
void checkMousePressed() {
  if (mouseButton==LEFT && inf != 0) { 
    time = millis();
    score=0;
    try {
      if (playMusic == true) {
        music.loop();
      }
    }
    catch(NullPointerException n) {
      setup();
      save[1]=String.valueOf(highScore);
    }
    inf = 0;
  }
  if (mouseButton==RIGHT) {
    inf=3;
  }
}

//This will run, at the end of a Game
void end() {
  try {
    if (playMusic == true) {
      music.stop();
      lose.play();
    }
  }
  catch (NullPointerException n) {
  }
  inf=1;
  key='`';
  if (highScore<score) {
    highScore=score;
  }
  try {
    save[1]=String.valueOf(highScore);
  }
  catch(ArrayIndexOutOfBoundsException a) {
  }
  saveStrings("gameInfo.app", save);
  retryConnection();
  reset();
}

//To avoid, that things will be runned more, than one time
void keyPressed() {
  if (pressKey == 0) {
    pressKey = 255;
    checkPressed();
  }
}
void keyReleased() {
  if (pressKey ==255) {
    pressKey = 0;
  }
}
//To avoid, that things will be runned more, than one time
void mouseClicked() {
  if (pressMouse == 0) {
    pressMouse = 255;
    checkMousePressed();
  }
}
void mouseReleased() {
  if (pressMouse == 255) {
    pressMouse = 0;
    checkMousePressed();
  }
}
