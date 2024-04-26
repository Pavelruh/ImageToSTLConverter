void sliderSize(float value) {
  imgScale = value;
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
void sliderSmoothing(int value){
  smoothingWidth = value;
}
void sliderPPM(int value){
  PPM = value;
}
void sliderHeight(float value){
  layerHeight = value;
}

void switchEdges(boolean value){
  edges = !edges;
  changeFlag = true;
}
void switchBlur(boolean value){
  blur = !blur;
  sliderBlur.setVisible(blur);
  if(blur) blurOffset = 1;
  else blurOffset = 0;
  // Сдвинуть все кнопки при появлении слайдеров
  offsetControl();
  changeFlag = true;
}
void switchNoise(boolean value){
  noise = !noise;
  sliderMean.setVisible(noise);
  sliderVariance.setVisible(noise);
  if(noise) noiseOffset = 1;
  else noiseOffset = 0;
  // Сдвинуть все кнопки при появлении слайдеров
  offsetControl();
  changeFlag = true;
}
void switchSmoothing(boolean value){
  smoothing = !smoothing;
  changeFlag = true;
  sliderSmoothing.setVisible(smoothing);
  if(smoothing) buttonSmoothing(true);
  else {
    smoothingWidth = 1;
    sliderSmoothing.setValue(1);
  }
}
void buttonSmoothing(boolean value){
  changeFlag = true;
  imgAl = smoothing(img3, smoothingWidth);
}

void buttonReset(){
  bright = 0.0;
  contrst = 1.0;
  imgScale = frameHeight / (float)min(originalImg.height, originalImg.width);
  smoothingWidth = 1;
  sliderBrightness.setValue(bright);
  sliderContrast.setValue(contrst);
  sliderSize.setValue(imgScale);
  switchEdges.setValue(false);
  switchBlur.setValue(false);
  switchNoise.setValue(false);
  sliderBlur.setVisible(false);
  sliderSmoothing.setVisible(false).setValue(1);
  sliderMean.setVisible(false).setValue(0);
  sliderVariance.setVisible(false).setValue(0);
  blur = false;
  blurOffset = 0;
  edges = false;
  smoothing = false;
  noise = false;
  noiseOffset = 0;
  imgX1 = 0;
  imgY1 = 0;
  offsetControl();
  changeFlag = true;
  quantized = false;
  saved = false;
}
void buttonSave() {
  img2.save("Output.png");
  img3.save("Output_quantized.png");
  if(smoothing) {
    imgAl.save("Output_smoothing.png");
    divideImage(imgAl);
  }
  else divideImage(img3);
  saved = true;
  println("Files were saved");
}
void buttonLoad() {
  selectInput("Select a file to process:", "fileSelected");
}
void buttonQuantize(){
  img3 = kMeans(img2);
  quantized = true;
}
void buttonConvert(){
  if(quantized && saved){
    for(int i = 0; i < colorNb; i++){
      String name = "color_" + i;
      createSTL(name, dividedImg[i]);
    }
  }
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
  }
}
void offsetControl(){
  // Сдвинуть все кнопки при появлении слайдеров
  sliderMean.setPosition(20, (5 + blurOffset + 2*noiseOffset)*offset);
  sliderVariance.setPosition(20, (6 + blurOffset + 2*noiseOffset)*offset);
  sliderColors.setPosition(20, (7 + blurOffset + 2*noiseOffset)*offset);
  sliderIterations.setPosition(20, (8 + blurOffset + 2*noiseOffset)*offset);
  buttonQuantize.setPosition(20, (9 + blurOffset + 2*noiseOffset)*offset);
  buttonSave.setPosition(20, (10 + blurOffset + 2*noiseOffset)*offset);
  switchSmoothing.setPosition(20, (11 + blurOffset + 2*noiseOffset)*offset);
  buttonSmoothing.setPosition(100, (11 + blurOffset + 2*noiseOffset)*offset);
  sliderSmoothing.setPosition(20, (13 + blurOffset + 2*noiseOffset)*offset);
}
