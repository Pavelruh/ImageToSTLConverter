int randPoint;
int[] centroids, centroidsNew;
float[] meanR, meanG, meanB;
int[] clustersCount;
int[] clustersR, clustersG, clustersB;
float convergenceThreshold = 1.0;
PImage[] dividedImg;

int distance(color a, color b){
  int aR, aG, aB;
  int bR, bG, bB;
  
  aR = (a >> 16) & 0xFF;
  aG = (a >> 8) & 0xFF;
  aB = a & 0xFF;
  
  bR = (b >> 16) & 0xFF;
  bG = (b >> 8) & 0xFF;
  bB = b & 0xFF;
  
  return (int)(pow((bR - aR), 2) + pow((bG - aG), 2) + pow((bB - aB), 2));
}

int getClosestCentroidIndex(int pixel) {
  int minDist = Integer.MAX_VALUE;
  int index = 0;

  for (int i = 0; i < colorNb; i++) {
    int dist = distance(pixel, centroids[i]);
    if (dist < minDist) {
      minDist = dist;
      index = i;
    }
  }

  return index;
}

// Проверка сходимости алгоритма по критерию
boolean checkConvergence(float threshold) {
  boolean converged = true;
  for (int i = 0; i < colorNb; i++) {
    // Расстояние между текущим и новым положением центроида
    float distance = distance(centroids[i], centroidsNew[i]); 
    if (distance > threshold) {
      // Если хотя бы один центроид сместился на расстояние больше порога, алгоритм не сошелся
      converged = false; 
      break;
    }
  }
  return converged;
}

void divideImage(PImage INPUT){
  dividedImg = new PImage[colorNb];
  for(int i = 0; i < colorNb; i++){
    dividedImg[i] = createImage(INPUT.width, INPUT.height, ARGB);
    for(int j = 0; j < INPUT.pixels.length; j++){
      if(INPUT.pixels[j] == centroids[i]) dividedImg[i].pixels[j] = 0xFFFFFFFF;
      else dividedImg[i].pixels[j] = 0xFF000000;
    }
    dividedImg[i].save("/divided images/Img_col_" + i + ".png");
  }
}

PImage kMeans(PImage INPUT){
  boolean converged = false;
  PImage OUTPUT = createImage(INPUT.width, INPUT.height, ARGB);
  centroids = new int[colorNb];
  centroidsNew = new int[colorNb];
  meanR = new float[colorNb];
  meanG = new float[colorNb];
  meanB = new float[colorNb];
  clustersCount = new int[colorNb];
  clustersR = new int[colorNb];
  clustersG = new int[colorNb];
  clustersB = new int[colorNb];
  // случайно расставляю центроиды
  for(int i = 0; i < colorNb; i++){
    // выбираем случайный пиксель
    randPoint = (int)random(INPUT.pixels.length);
    // получаем прозрачность этого пикселя
    int A = (INPUT.pixels[randPoint] >> 24) & 0xFF;
    // если он прозрачный, меняем пиксель, пока не получим нормальный 
    while(A == 0x00){
      randPoint = (int)random(INPUT.pixels.length);
      A = (INPUT.pixels[randPoint] >> 24) & 0xFF;
    }
    // цвет центроида(координаты в RGB)
    centroids[i] = INPUT.pixels[randPoint];
    
    // если есть 2 центроида одного цвета, повторяем заново
    for(int j = 0; j < i; j++){
      if(centroids[j] == centroids[i]){
        i--;
        break;
      }
    }
  }
  converged = false;
  for (int iter = 0; iter < iterations && !converged; iter++) {
    // Очищаем счетчики и суммы перед каждой итерацией
    for (int i = 0; i < colorNb; i++) {
      clustersCount[i] = 0;
      clustersR[i] = 0;
      clustersG[i] = 0;
      clustersB[i] = 0;
    }
    // пробегаемся по всем пикселям
    for(int i = 0; i < INPUT.pixels.length; i++){
      int R, G, B, A;
      // получаем индекс ближайшего центроида для этого пикселя
      int index = getClosestCentroidIndex(INPUT.pixels[i]);
      // получаем цвет и прозрачность пикселя
      int col = INPUT.pixels[i];
      A = (col >> 24) & 0xFF;
      
      // если пикслель НЕ прозрачный
      if(A != 0x00){
        // считаем кол-во пикселей, принадлежащих этому центроиду
        clustersCount[index]++;
        
        // получаем компоненты цвета
        R = (col >> 16) & 0xFF;
        G = (col >> 8) & 0xFF;
        B = col & 0xFF;
        
        // считаем сумму компонентов
        clustersR[index] += R;
        clustersG[index] += G;
        clustersB[index] += B;
      }
    }
    
    // для всех выбранных цветов
    for(int i = 0; i < colorNb; i++){
      if(clustersCount[i] > 0){
        // если в кластере есть цвета, считаем средний цвет кластера
        meanR[i] = clustersR[i] / clustersCount[i];
        meanG[i] = clustersG[i] / clustersCount[i];
        meanB[i] = clustersB[i] / clustersCount[i];
        // получаем новый центроид из среднего цвета кластера
        centroids[i] = (0xFF << 24) | ((int)meanR[i] << 16) | ((int)meanG[i] << 8) | (int)meanB[i];
      }
    }
    // Проверяем сходимость критерием
    if (checkConvergence(convergenceThreshold)) converged = true;
  }
  for(int i = 0; i < INPUT.pixels.length; i++){
    int col = INPUT.pixels[i];
    int A = (col >> 24) & 0xFF;
    color newCol;
    if(A != 0x00) newCol = centroids[getClosestCentroidIndex(col)];
    else newCol = 0x00FFFFFF;
    OUTPUT.pixels[i] = newCol;
  }
  println("Quantization done", colorNb, iterations, "Converged -", converged);
  return OUTPUT;
}
