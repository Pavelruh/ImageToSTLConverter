void sliderSize(float value) {
  imgScale = value;
  // changeFlag = true;
}
void sliderBrightness(float value){
  bright = value * 2.55;
  changeFlag = true;
}
void sliderContrast(float value){
  contrst = value;
  changeFlag = true;
}
void sliderBlur(int value){
  blurWidth = value;
  changeFlag = true;
}
void sliderMean(int value){
  mean = value;
  changeFlag = true;
}
void sliderVariance(int value){
  variance = value;
  changeFlag = true;
}
void sliderColors(int value){
  colorNb = value;
}
void sliderIterations(int value){
  iterations = value;
}
void sliderAliasing(int value){
  aliasingWidth = value;
}

void switchEdges(boolean value){
  edges = !edges;
  changeFlag = true;
}
void switchBlur(boolean value){
  blur = !blur;
  sliderBlur.setVisible(blur);
  if(blur) isBlur = 1;
  else isBlur = 0;
  // Сдвинуть все кнопки при появлении слайдеров
  offsetControl();
  changeFlag = true;
}
void switchNoise(boolean value){
  noise = !noise;
  sliderMean.setVisible(noise);
  sliderVariance.setVisible(noise);
  if(noise) isNoise = 1;
  else isNoise = 0;
  offsetControl();
  changeFlag = true;
}
void switchAliasing(boolean value){
  aliasing = !aliasing;
  changeFlag = true;
  sliderAliasing.setVisible(aliasing);
  if(aliasing) buttonAliasing(true);
  else {
    aliasingWidth = 1;
    sliderAliasing.setValue(1);
  }
}
void buttonAliasing(boolean value){
  changeFlag = true;
  imgAl = aliasing(img3, aliasingWidth);
}

void buttonReset(){
  bright = 0.0;
  contrst = 1.0;
  imgScale = frameHeight / (float)min(originalImg.height, originalImg.width);
  aliasingWidth = 1;
  sliderBrightness.setValue(bright);
  sliderContrast.setValue(contrst);
  sliderSize.setValue(imgScale);
  switchEdges.setValue(false);
  switchBlur.setValue(false);
  switchNoise.setValue(false);
  sliderBlur.setVisible(false);
  sliderAliasing.setVisible(false).setValue(1);
  sliderMean.setVisible(false).setValue(0);
  sliderVariance.setVisible(false).setValue(0);
  blur = false;
  isBlur = 0;
  edges = false;
  aliasing = false;
  noise = false;
  isNoise = 0;
  imgX1 = 0;
  imgY1 = 0;
  offsetControl();
  changeFlag = true;
}
void buttonSave() {
  // Обработка кнопки
  // img1.save("Output.png");
  img2.save("Output.png");
  img3.save("Output_quantized.png");
  if(aliasing) imgAl.save("Output_Aliasing.png");
  println("Files were saved");
}
void buttonLoad() {
  selectInput("Select a file to process:", "fileSelected");
}
void buttonQuantize(){
  img3 = kMeans(img2);
  // changeFlag = true;
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Not selected");
  } else {
    imagePath = selection.getAbsolutePath();
    println("Select: " + imagePath);
    originalImg = loadImage(imagePath);
    img1 = originalImg;
    buttonReset();
    // imgScale = frameHeight / (float)min(originalImg.height, originalImg.width);
    // buttonReset();
    // imgX1 = 0;
    // imgY1 = 0;
  }
}
void offsetControl(){
  // Сдвинуть все кнопки при появлении слайдеров
  sliderMean.setPosition(20, (5 + isBlur + 2*isNoise)*offset);
  sliderVariance.setPosition(20, (6 + isBlur + 2*isNoise)*offset);
  sliderColors.setPosition(20, (7 + isBlur + 2*isNoise)*offset);
  sliderIterations.setPosition(20, (8 + isBlur + 2*isNoise)*offset);
  buttonQuantize.setPosition(20, (9 + isBlur + 2*isNoise)*offset);
  buttonSave.setPosition(20, (10 + isBlur + 2*isNoise)*offset);
  switchAliasing.setPosition(20, (11 + isBlur + 2*isNoise)*offset);
  buttonAliasing.setPosition(100, (11 + isBlur + 2*isNoise)*offset);
  sliderAliasing.setPosition(20, (13 + isBlur + 2*isNoise)*offset);
}
