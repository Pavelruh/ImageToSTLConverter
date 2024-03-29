boolean isOnImg(){
  // if(mouseX > imgX1 && mouseX < imgX1 + originalImg.width && mouseY > imgY1 && mouseY < imgY1 + originalImg.height) return true;
  if(mouseX > Xframe1 && mouseX < Xframe1 + frameWidth && mouseY > Yframe && mouseY < Yframe + frameHeight) return true;
  else return false;
}
void mouseWheel(MouseEvent event) {
  // Масштабирование колесиком мыши
  if(isOnImg()) {
    float e = event.getCount();
    imgScale -= e * 0.1;
     cp5.getController("sliderSize").setValue(imgScale);
    if(imgScale <= 0.01) imgScale = 0.01;
    else if(imgScale >= 3) imgScale = 3;
    // println(imgScale);
  }
}
void mousePressed() {
  // проверяем, было ли нажатие на изображение
  if (isOnImg()) {
    imgClicked = true;
  } 
  else imgClicked = false;
}

void mouseDragged() {
  // если изображение было нажато, перемещаем его вместе с мышью
  if (imgClicked) {
    imgX1 = ((mouseX - Xframe1) / imgScale) - originalImg.width / 2;
    imgY1 = ((mouseY - Yframe) / imgScale) - originalImg.height / 2;
  }
}

void mouseReleased() {
  // сбрасываем флаг при отпускании мыши
  imgClicked = false;
}
