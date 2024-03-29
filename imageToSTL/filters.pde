PImage ContrastAndBrightness (PImage input, float cont, float bright) {
  int w = input.width;
  int h = input.height;
  
  PImage output = createImage(w, h, ARGB);

  // this is required before manipulating the image pixels directly
  input.loadPixels();
  output.loadPixels();

  // loop through all pixels in the image
  for (int i = 0; i < w*h; i++)
  {  
    // get color values from the current pixel (which are stored as a list of type 'color')
    color inColor = input.pixels[i];

    // slow version for illustration purposes - calling a function inside this loop
    // is a big no no, it will be very slow, plust we need an extra cast
    // as this loop is being called w * h times, that can be a million times or more!
    // so comment this version and use the one below
    // int r = (int) red(input.pixels[i]);
    // int g = (int) green(input.pixels[i]);
    // int b = (int) blue(input.pixels[i]);

    // here the much faster version (uses bit-shifting) - uncomment to try
    int a = (inColor >> 24) & 0xFF;
    int r = (inColor >> 16) & 0xFF; // like calling the function red(), but faster
    int g = (inColor >> 8) & 0xFF;
    int b = inColor & 0xFF;      

    // apply contrast (multiplcation) and brightness (addition)
    r = (int)(r * cont + bright); // floating point aritmetic so convert back to int with a cast (i.e. '(int)');
    g = (int)(g * cont + bright);
    b = (int)(b * cont + bright);

    // slow but absolutely essential - check that we don't overflow (i.e. r,g and b must be in the range of 0 to 255)
    // to explain: this nest two statements, sperately it would be r = r < 0 ? 0 : r; and r = r > 255 ? 255 : 0;
    // you can also do this with if statements and it would do the same just take up more space
    r = r < 0 ? 0 : r > 255 ? 255 : r;
    g = g < 0 ? 0 : g > 255 ? 255 : g;
    b = b < 0 ? 0 : b > 255 ? 255 : b;

    // and again in reverse for illustration - calling the color function is slow so use the bit-shifting version below
    // output.pixels[i] = color(r, g, b);
    output.pixels[i] = (a << 24) | (r << 16) | (g << 8) | b; // this does the same but faster
  }

  // so that we can display the new image we must call this for each image
  input.updatePixels();
  output.updatePixels();
  return output;
}

int[][] kernel = {
  { -1, -1, -1}, 
  { -1, 9, -1}, 
  { -1, -1, -1}
};

PImage findEdges(PImage input) {
  input.loadPixels();
  PImage output = createImage(input.width, input.height, ARGB);
  
  // пробегаемся по всем пикселям по ширине и высоте изображения
  for (int y = 0; y < input.height; y++) {
    for (int x = 0; x < input.width; x++) {
      int sumR = 0, sumG = 0, sumB = 0;
      // для каждого пикселя пробегаемся по пикселям соседям
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          int X = x+kx, Y = y+ky;
          
          // если вышли за рамки изображения, отзеркаливаем по краю(-1 -> 1, 452 -> 448)
          if(X < 0) X = -X;
          else if(X >= input.width) X = 2*input.width - X - 1;
          
          if(Y < 0) Y = -Y;
          else if(Y >= input.height) Y = 2*input.height - Y - 1;
          
          int pos = Y*input.width + X;
          int col = input.pixels[pos];
          
          // получаем составляющие пикселя
          int valR = (col >> 16) & 0xFF;
          int valG = (col >> 8) & 0xFF;
          int valB = col & 0xFF; 
          // считаем сумму для каждой составляющей(кроме прозрачности) с маской кернела
          sumR += kernel[ky+1][kx+1] * valR;
          sumG += kernel[ky+1][kx+1] * valG;
          sumB += kernel[ky+1][kx+1] * valB;
        }
      } 
      // Ограничиваем значения составляющих
      sumR = sumR < 0 ? 0 : sumR > 255 ? 255 : sumR;
      sumG = sumG < 0 ? 0 : sumG > 255 ? 255 : sumG;
      sumB = sumB < 0 ? 0 : sumB > 255 ? 255 : sumB;
      // sumR = constrain(sumR, 0, 255);
      // sumG = constrain(sumG, 0, 255);
      // sumB = constrain(sumB, 0, 255);
      
      int col = input.pixels[y*input.width + x];
      int A = (col >> 24) & 0xFF;
      int outCol = (A << 24) | (sumR << 16) | (sumG << 8) | sumB;
      output.pixels[y*input.width + x] = outCol;
    }
  }
  output.updatePixels();
  return output;
}

PImage blur(PImage input, int blurRadius){
  input.loadPixels();
  PImage output = createImage(input.width, input.height, ARGB);
  
  // пробегаемся по всем пикселям по ширине и высоте изображения
  for (int y = 0; y < input.height; y++) {
    for (int x = 0; x < input.width; x++) {
      float sumR = 0, sumG = 0, sumB = 0, sumA = 0;
      // для каждого пикселя пробегаемся по пикселям соседям в радиусе
      for (int ky = -blurRadius; ky <= blurRadius; ky++) {
        for (int kx = -blurRadius; kx <= blurRadius; kx++) {
          int X = x+kx, Y = y+ky;
          
          // если вышли за рамки изображения, отзеркаливаем по краю(-1 -> 1, 452 -> 448)
          if(X < 0) X = -X;
          else if(X >= input.width) X = 2*input.width - X - 1;
          
          if(Y < 0) Y = -Y;
          else if(Y >= input.height) Y = 2*input.height - Y - 1;
          
          int pos = Y * input.width + X;
          int col = input.pixels[pos];
          
          // получаем составляющие пикселя
          int valA = (col >> 24) & 0xFF;
          int valR = (col >> 16) & 0xFF;
          int valG = (col >> 8) & 0xFF;
          int valB = col & 0xFF; 
          
          // Считаем сумму для каждой составляющей
          sumA += valA;
          sumR += valR;
          sumG += valG;
          sumB += valB;
        }
      }
      // Кол-во проверенных пикселей - ширина в квадрате (2 радиуса + центр)
      int square = (2*blurRadius+1) * (2*blurRadius+1);
      // Получаем новый цвет из составляющих / на кол-во пикселей
      int outCol = ((int)(sumA/square) << 24) | ((int)(sumR/square) << 16) | ((int)(sumG/square) << 8) | (int)(sumB/square);
      output.pixels[(y*input.width) + x] = outCol;
    }
  }
  output.updatePixels();
  return output;
}

PImage addNoise(PImage INPUT, float mean, float variance){
  INPUT.loadPixels();
  PImage OUTPUT = createImage(INPUT.width, INPUT.height, ARGB);
  
  // Пробегаемся по всем пикселям по ширине и высоте изображения
  for (int y = 0; y < INPUT.height; y++) {
    for (int x = 0; x < INPUT.width; x++) {
      int pos = y * INPUT.width + x;
      int col = INPUT.pixels[pos];
      
      // Генерируем два случайных числа в интервале [0, 1]
      float r1 = random(1);
      float r2 = random(1);
      
      // Применяем преобразование Бокса-Мюллера для получения случайного числа с нормальным распределением
      float z = sqrt(-2 * log(r1)) * cos(2 * PI * r2); 
      
      // Получаем составляющие пикселя
      int A = (col >> 24) & 0xFF;
      int R = (col >> 16) & 0xFF;
      int G = (col >> 8) & 0xFF;
      int B = col & 0xFF; 
      
      // Применяем случайное значение к каждому каналу цвета
      R = (int)(R + z * variance + mean);
      G = (int)(G + z * variance + mean);
      B = (int)(B + z * variance + mean);
      
      // Ограничиваем значения составляющих
      R = R < 0 ? 0 : R > 255 ? 255 : R;
      G = G < 0 ? 0 : G > 255 ? 255 : G;
      B = B < 0 ? 0 : B > 255 ? 255 : B;
      
      int outCol = (A << 24) | (R << 16) | (G << 8) | B;
      OUTPUT.pixels[pos] = outCol;
    }
  }
  OUTPUT.updatePixels();
  return OUTPUT;
}

PImage aliasing(PImage INPUT, int aliasingRadius){
  INPUT.loadPixels();
  PImage OUTPUT = createImage(INPUT.width, INPUT.height, ARGB);
  
  // пробегаемся по всем пикселям по высоте и ширине
  for (int y = 0; y < INPUT.height; y++) {
    for (int x = 0; x < INPUT.width; x++) {
      int len = 2*aliasingRadius + 1;
      
      // массив пикселей в квадрате вокруг нынешнего пикселя
      int[] colors = new int[len*len];
      // массив разных цветов пикселей
      int[] colorsCount = new int[len*len];
      
      // для каждого пикселя пробегаемся по пикселям соседям в радиусе
      for (int ky = -aliasingRadius; ky <= aliasingRadius; ky++) {
        for (int kx = -aliasingRadius; kx <= aliasingRadius; kx++) {
          int X = x+kx, Y = y+ky;
          
          // если вышли за рамки изображения, отзеркаливаем по краю(-1 -> 1, 452 -> 448)
          if(X < 0) X = -X;
          else if(X >= INPUT.width) X = 2*INPUT.width - X - 1;
          
          if(Y < 0) Y = -Y;
          else if(Y >= INPUT.height) Y = 2*INPUT.height - Y - 1;
          
          int pos = Y * INPUT.width + X;
          int col = INPUT.pixels[pos];
          
          // получаем часть изображения вокруг пикселя
          colors[(ky+aliasingRadius)*len + (kx+aliasingRadius)] = col;
        }
      }
      
      // Считаем частоту встречаемости каждого цвета
      for (int i = 0; i < len*len; i++) {
        for (int j = i; j < len*len; j++) {
          if (colors[i] == colors[j]) {
            colorsCount[i]++;
          }
        }
      }
      // Находим индекс самого часто встречающегося цвета
      int maxIndex = 0;
      for (int i = 1; i < len*len; i++) {
        if (colorsCount[i] > colorsCount[maxIndex]) {
          maxIndex = i;
        }
      }
      boolean allEqual = true;
      for (int count : colorsCount) {
        if (count != colorsCount[maxIndex]) {
          allEqual = false;
          break;
        }
      }
    
      // Если все цвета встречаются одинаково часто, возвращаем цвет из середины массива
      if (allEqual) OUTPUT.pixels[(y * INPUT.width) + x] = colors[aliasingRadius];
      else OUTPUT.pixels[(y * INPUT.width) + x] = colors[maxIndex];
    }
  }
  OUTPUT.updatePixels();
  println("aliasing done", aliasingRadius);
  return OUTPUT;
}
