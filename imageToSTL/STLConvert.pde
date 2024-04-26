PrintWriter output;
float x1, y1, x2, y2;

void createSTL(String name, PImage input) {
  output = createWriter("/output stl/" + name + ".stl"); // Создаем файл output.stl для записи
  output.println("solid ascii_stl " + name);

  input.loadPixels();
  for (int y = 0; y < input.height; y++) {
    for (int x = 0; x < input.width; x++) {
      findRect(input, x, y);
    }
  }

  output.println("endsolid ascii_stl");
  println("stl created");
  output.flush(); // Принудительно записываем данные в файл
  output.close(); // Закрываем файл
}

void findRect(PImage input, int x, int y) {
  if (input.pixels[y*input.width + x] == 0xFFFFFFFF) {
    x1 = x / PPM;
    y1 = y / PPM;
    int maxWidth = 0, maxHeight = 0;

    // Find the maximum width of the rectangle
    for (int l = 0; x + l < input.width && input.pixels[y*input.width + x+l] == 0xFFFFFFFF; l++) {
      maxWidth++; // Adjusted to include the current pixel
    }

    // Find the maximum height of the rectangle
    for (int h = 0; y + h < input.height && input.pixels[(y+h) * input.width+x] == 0xFFFFFFFF && h < maxWidth; h++) {
      int currentWidth = 0;
      for (int l = 0; l < maxWidth && x+l < input.width; l++) {
        currentWidth++;
        if (x+l >= input.width || input.pixels[(y+h)*input.width + x+l] != 0xFFFFFFFF) break;
      }
      if (currentWidth != maxWidth) break;
      maxHeight++;
    }
    x2 = (x+maxWidth) / PPM;
    y2 = (y+maxHeight) / PPM;
    //println("p1 = ", x1,y1,"p2 = ",x2,y2, "dim = ", x2-x1+1,"*", y2-y1+1);
    createCube(x1, y1, x2, y2, layerHeight);

    //закрашиваем получившийся наибольший прямоугольник
    colorMode(HSB, 255);
    int randHue = (int)random(0, 255);
    for (int j = 0; j < maxHeight; j++) {
      for (int i = 0; i < maxWidth; i++) {
        input.pixels[constrain((y+j)*input.width + x+i, 0, input.pixels.length - 1)] = color(randHue, 255, 255);
      }
    }
    colorMode(RGB, 255);
  }
}

void createCube(float x1, float y1, float x2, float y2, float Height) {
  // Определение вершин куба
  float z1 = 0;
  float z2 = Height;

  // По Z
  output.println("  facet normal 0 0 1");
  output.println("    outer loop");
  output.println("      vertex " + x1 + " " + y1 + " " + z2);
  output.println("      vertex " + x2 + " " + y1 + " " + z2);
  output.println("      vertex " + x2 + " " + y2 + " " + z2);
  output.println("    endloop");
  output.println("  endfacet");
  output.println("  facet normal 0 0 1");
  output.println("    outer loop");
  output.println("      vertex " + x1 + " " + y1 + " " + z2);
  output.println("      vertex " + x2 + " " + y2 + " " + z2);
  output.println("      vertex " + x1 + " " + y2 + " " + z2);
  output.println("    endloop");
  output.println("  endfacet");

  output.println("  facet normal 0 0 -1");
  output.println("    outer loop");
  output.println("      vertex " + x1 + " " + y1 + " " + z1);
  output.println("      vertex " + x2 + " " + y1 + " " + z1);
  output.println("      vertex " + x2 + " " + y2 + " " + z1);
  output.println("    endloop");
  output.println("  endfacet");
  output.println("  facet normal 0 0 -1");
  output.println("    outer loop");
  output.println("      vertex " + x1 + " " + y1 + " " + z1);
  output.println("      vertex " + x2 + " " + y2 + " " + z1);
  output.println("      vertex " + x1 + " " + y2 + " " + z1);
  output.println("    endloop");
  output.println("  endfacet");

  // По X
  output.println("  facet normal -1 0 0");
  output.println("    outer loop");
  output.println("      vertex " + x1 + " " + y1 + " " + z1);
  output.println("      vertex " + x1 + " " + y2 + " " + z1);
  output.println("      vertex " + x1 + " " + y2 + " " + z2);
  output.println("    endloop");
  output.println("  endfacet");
  output.println("  facet normal -1 0 0");
  output.println("    outer loop");
  output.println("      vertex " + x1 + " " + y1 + " " + z1);
  output.println("      vertex " + x1 + " " + y2 + " " + z2);
  output.println("      vertex " + x1 + " " + y1 + " " + z2);
  output.println("    endloop");
  output.println("  endfacet");

  output.println("  facet normal 1 0 0");
  output.println("    outer loop");
  output.println("      vertex " + x2 + " " + y1 + " " + z1);
  output.println("      vertex " + x2 + " " + y1 + " " + z2);
  output.println("      vertex " + x2 + " " + y2 + " " + z1);
  output.println("    endloop");
  output.println("  endfacet");
  output.println("  facet normal 1 0 0");
  output.println("    outer loop");
  output.println("      vertex " + x2 + " " + y2 + " " + z1);
  output.println("      vertex " + x2 + " " + y1 + " " + z2);
  output.println("      vertex " + x2 + " " + y2 + " " + z2);
  output.println("    endloop");
  output.println("  endfacet");

  // По Y
  output.println("  facet normal -1 0 0");
  output.println("    outer loop");
  output.println("      vertex " + x1 + " " + y1 + " " + z1);
  output.println("      vertex " + x1 + " " + y1 + " " + z2);
  output.println("      vertex " + x2 + " " + y1 + " " + z1);
  output.println("    endloop");
  output.println("  endfacet");
  output.println("  facet normal -1 0 0");
  output.println("    outer loop");
  output.println("      vertex " + x2 + " " + y1 + " " + z1);
  output.println("      vertex " + x1 + " " + y1 + " " + z2);
  output.println("      vertex " + x2 + " " + y1 + " " + z2);
  output.println("    endloop");
  output.println("  endfacet");

  output.println("  facet normal 1 0 0");
  output.println("    outer loop");
  output.println("      vertex " + x1 + " " + y2 + " " + z1);
  output.println("      vertex " + x1 + " " + y2 + " " + z2);
  output.println("      vertex " + x2 + " " + y2 + " " + z1);
  output.println("    endloop");
  output.println("  endfacet");
  output.println("  facet normal 1 0 0");
  output.println("    outer loop");
  output.println("      vertex " + x2 + " " + y2 + " " + z1);
  output.println("      vertex " + x1 + " " + y2 + " " + z2);
  output.println("      vertex " + x2 + " " + y2 + " " + z2);
  output.println("    endloop");
  output.println("  endfacet");
}
