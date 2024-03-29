Slider sliderSize, sliderBrightness, sliderContrast, sliderBlur, sliderMean, sliderVariance, sliderColors, sliderIterations, sliderAliasing;
Button buttonLoad, buttonReset, buttonSave, buttonQuantize, buttonAliasing;
Toggle switchEdges, switchBlur, switchNoise, switchAliasing;

void GUISet(){
  sliderSize.setValue(imgScale);
  sliderBrightness.setValue(0.0);
  sliderContrast.setValue(1.0);
  sliderMean.setValue(0);
  sliderVariance.setValue(0);
  sliderColors.setValue(4);
  sliderIterations.setValue(50);
}

void GUIinit(){
  ControlFont menuFont = new ControlFont(createFont("Arial", 14));
  cp5.setFont(menuFont);
  
  buttonLoad = cp5.addButton("buttonLoad")
    .setCaptionLabel("OPEN")
    .setPosition(20, offset)
    .setSize(95, 30)
    ;
    
  buttonReset = cp5.addButton("buttonReset")
    .setCaptionLabel("Reset")
    .setPosition(125, offset)
    .setSize(95, 30)
    ;
  
  sliderSize = cp5.addSlider("sliderSize")
    .setPosition(20, 2*offset)
    .setRange(0.1, 3)
    .setValue(imgScale)
    .setSize(200, 30)
    .setCaptionLabel("Image Size")
    ;
  cp5.getController("sliderSize").getCaptionLabel().setPaddingX(-85);
  
  sliderBrightness = cp5.addSlider("sliderBrightness")
    .setPosition(20, 3*offset)
    .setRange(-100, 100)
    .setValue(bright)
    .setSize(200, 30)
    .setCaptionLabel("Brightness")
    .setNumberOfTickMarks(201)
    .showTickMarks(false)
    .setDecimalPrecision(0);
    ;
  cp5.getController("sliderBrightness").getCaptionLabel().setPaddingX(-96);
  
  sliderContrast = cp5.addSlider("sliderContrast")
    .setPosition(20, 4*offset)
    .setRange(0, 5)
    .setValue(contrst)
    .setSize(200, 30)
    .setCaptionLabel("Contrast")
    .setDecimalPrecision(2);
    ;
  cp5.getController("sliderContrast").getCaptionLabel().setPaddingX(-80);
  
  switchEdges = cp5.addToggle("switchEdges")
    .setPosition(20, 5*offset)
    .setSize(60, 30)
    .setCaptionLabel("Edges")
    .setMode(ControlP5.SWITCH)
    ;
  
  switchBlur = cp5.addToggle("switchBlur")
    .setPosition(90, 5*offset)
    .setSize(60, 30)
    .setCaptionLabel("Blur")
    .setMode(ControlP5.SWITCH)
    ;
    
  switchNoise = cp5.addToggle("switchNoise")
    .setPosition(160, 5*offset)
    .setSize(60, 30)
    .setCaptionLabel("Noise")
    .setMode(ControlP5.SWITCH)
    ;
  
  sliderBlur = cp5.addSlider("sliderBlur")
    .setPosition(20, 7*offset-10)
    .setRange(1, 10)
    .setValue(blurWidth)
    .setNumberOfTickMarks(10)
    .setSize(200, 30)
    .setVisible(false)
    .setCaptionLabel("Blur Raduis")
    ;
  cp5.getController("sliderBlur").getCaptionLabel().setPaddingX(-100);
  
  sliderMean = cp5.addSlider("sliderMean")
    .setPosition(20, 7*offset-10)
    .setRange(-100, 100)
    .setValue(mean)
    //.setNumberOfTickMarks(201)
    .setSize(200, 30)
    .setVisible(false)
    //.showTickMarks(false)
    .setCaptionLabel("Mean value")
    ;
  cp5.getController("sliderMean").getCaptionLabel().setPaddingX(-95);
  
  sliderVariance = cp5.addSlider("sliderVariance")
    .setPosition(20, 8*offset-10)
    .setRange(0, 100)
    .setValue(variance)
    //.setNumberOfTickMarks(101)
    .setSize(200, 30)
    .setVisible(false)
    //.showTickMarks(false)
    .setCaptionLabel("Variance")
    ;
  cp5.getController("sliderVariance").getCaptionLabel().setPaddingX(-75);
  
  sliderColors = cp5.addSlider("sliderColors")
    .setPosition(20, 7*offset)
    .setRange(2, 64)
    .setNumberOfTickMarks(62)
    .setValue(colorNb)
    .setSize(200, 30)
    .setCaptionLabel("Colors")
    .showTickMarks(false)
    // .setDecimalPrecision(0);
    ;
  cp5.getController("sliderColors").getCaptionLabel().setPaddingX(-65);
  
  sliderIterations = cp5.addSlider("sliderIterations")
    .setPosition(20, 8*offset)
    .setRange(1, 100)
    .setNumberOfTickMarks(100)
    .setValue(iterations)
    .setSize(200, 30)
    .setCaptionLabel("Iterations")
    .showTickMarks(false)
    // .setDecimalPrecision(0);
    ;
  cp5.getController("sliderIterations").getCaptionLabel().setPaddingX(-90);

  buttonQuantize = cp5.addButton("buttonQuantize")
    .setPosition(20, 9*offset)
    .setSize(150, 30)
    .setCaptionLabel("Quantize")
    ;
    
  buttonSave = cp5.addButton("buttonSave")
    .setPosition(20, 10*offset)
    .setSize(150, 30)
    .setCaptionLabel("Save Result")
    ;
    
  switchAliasing = cp5.addToggle("switchAliasing")
    .setPosition(20, 11*offset)
    .setSize(60, 30)
    .setCaptionLabel("Aliasing")
    .setMode(ControlP5.SWITCH)
    ;
    
  buttonAliasing = cp5.addButton("buttonAliasing")
    .setPosition(100, 11*offset)
    .setSize(80, 30)
    .setCaptionLabel("Aliasing")
    // .setMode(ControlP5.SWITCH)
    ;
    
  sliderAliasing = cp5.addSlider("sliderAliasing")
    .setPosition(20, 13*offset-10)
    .setRange(1, 5)
    .setValue(aliasingWidth)
    .setNumberOfTickMarks(5)
    .setSize(200, 30)
    .setVisible(false)
    .setCaptionLabel("Aliasing Raduis")
    ;
  cp5.getController("sliderAliasing").getCaptionLabel().setPaddingX(-125);
}
