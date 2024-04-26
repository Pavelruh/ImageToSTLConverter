import controlP5.*;

ControlP5 cp5;

PImage originalImg, img1, img2, img3, imgAl;
String imagePath;
float imgScale = 1.0;
int frameWidth = 512, frameHeight = 512, offset = 40, settingsWidth = 200;
float imgX1 = 0, imgY1 = 0;
int Xframe1 = settingsWidth + offset, Yframe = 30;
int Xframe2 = Xframe1 + frameWidth + 10;
int border;
boolean imgClicked = false, edges = false, blur = false, noise = false, smoothing = false;
boolean quantized = false, saved = false;
int blurOffset = 0, noiseOffset = 0;
boolean changeFlag = true;
int R, G, B;
float bright = 0.0, contrst = 1.0;
int blurWidth = 1, smoothingWidth = 1, mean = 0, variance = 10;

int colorNb = 8;
int iterations = 50;

float layerHeight = 0.4;
float PPM = 10;

void setup() {
  size(1280, 720);
  border = width;
  colorMode(ARGB, 255);
  
  // Инициализация библиотеки controlP5
  cp5 = new ControlP5(this);

  GUIinit();

  // Загрузка изображения
  imagePath = "noImage.jpg";
  originalImg = loadImage(imagePath);
  img2 = createImage(512, 512, ARGB);
  img3 = createImage(512, 512, ARGB);
  imgScale = frameHeight / (float)max(originalImg.height, originalImg.width);
  
  GUISet();
}

void draw() {
  background(#FFFFFFFF);
  
  drawFrame1();
  drawFrame2();
  
  // Обновление библиотеки controlP5
  cp5.draw();
}

void drawFrame1(){
  noFill();
  stroke(150);
  strokeWeight(border);
  
  pushMatrix();
  translate(Xframe1, Yframe);
  scale(imgScale);
  // img1 = originalImg;
  if(changeFlag){
    img1 = originalImg;
    img1 = ContrastAndBrightness(img1, contrst, bright);
    if(edges) img1 = findEdges(img1);
    if(blur) img1 = blur(img1, blurWidth);
    if(noise) img1 = addNoise(img1, mean * 2.55, variance);
    changeFlag = false;
  }
  
  image(img1, imgX1, imgY1);
  scale(1/imgScale);
  rect(-border/2, -border/2, frameWidth+border, frameHeight+border);
  
  stroke(0);
  strokeWeight(4);
  //rect(-4, -4, frameWidth+6, frameHeight+6);
  //img2.copy(img1, -(int)imgX1, -(int)imgY1, frameWidth, frameHeight, 0, 0, frameWidth, frameHeight); 
  popMatrix();
  img2 = get(Xframe1, Yframe, frameWidth, frameHeight);
}

void drawFrame2(){
  noFill();
  stroke(0);
  strokeWeight(4);
  
  pushMatrix();
  translate(Xframe2, Yframe);
  //rect(-3, -3, frameWidth+4, frameHeight+4);
  //image(img2, 0, 0);
  if(smoothing) {
    // imgAl = smoothing(img3, smoothingWidth);
    image(imgAl, 0, 0);
  }
  else image(img3, 0, 0);
  popMatrix();
}
