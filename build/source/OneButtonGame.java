import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class OneButtonGame extends PApplet {

// PGraphics pg;
PShader testShader;
GameObject obj;
Number number;

public void setup(){
  // fullScreen(P2D);
  
  surface.setResizable(true);
  frameRate(1000);
  

  Graphics.addShader("test.frag", loadShader("test.frag"));
  obj = new GameObject(ConstructedImages.test, "test.frag");
  number = new Number(0, 40, "test.frag");
  obj.position = new PVector(3, 10);
  number.transform(10, 20, 0.5f);
  number.setBaseColor(Colors.highlight);
  number.number = 1;
  Time.add("Input", 15);
  Time.add("Second", 1000);
}

public void draw(){
  resetShader();
  background(Colors.dark);
  fill(Colors.base);
  text(width + "x" + height, 10, 20);
  text(frameRate, 8, 35);
  text(Time.getTimer("Input"), 10, 50);
  text(keyCode, 10, 65);

  if (Time.getTimer("Second") <= 0)
    number.number++;
  if (keyPressed && Time.getTimer("Input") <= 0) {
    obj.position.y += key == 's' ? 1 : key == 'w' ? -1 : 0;
    obj.position.x += key == 'd' ? 1 : key == 'a' ? -1 : 0;
  }
  number.setPosition((int)(mouseX / Graphics.scale), (int)(mouseY / Graphics.scale));
  obj.draw();
  number.draw();

  Time.update(millis());
}
public static class Colors {
  static final int minIndexValue = 0;
  static final int maxIndexValue = 9;
  static final int alpha = 0;
  static int base = 0xFF77CC88;
  static int highlight = 0xFFEEEEEE;
  static int midtone = 0xFF888888;
  static int shadow = 0xFF555555;
  static int dark = 0xFF222222;
}

public int getColor(int index) {
  if (index == Colors.alpha) return 0x00000000;
  if (index > Colors.maxIndexValue - Colors.maxIndexValue / 3.3f) return Colors.shadow;
  if (index > Colors.maxIndexValue / 3.3f) return Colors.midtone;
  return Colors.highlight;
  // return lerpColor(Colors.shadow, Colors.highlight, map(index, Colors.maxIndexValue, Colors.minIndexValue, 0, 1));
}

public float getAlpha(int c) {
  return ((c & 0xFF000000) >> 24) / 255F;
}

public float getRed(int c, boolean alpha) {
  if (alpha) {
    return ((c & 0x00FF0000) >> 16) / 255F;
  } else {
    return ((c & 0xFF0000) >> 16) / 255F;
  }
}

public float getGreen(int c, boolean alpha) {
  if (alpha) {
    return ((c & 0x0000FF00) >> 8) / 255F;
  } else {
    return ((c & 0x00FF00) >> 8) / 255F;
  }
}

public float getBlue(int c, boolean alpha) {
  if (alpha) {
    return (c & 0x000000FF) / 255F;
  } else {
    return (c & 0x0000FF) / 255F;
  }
}

public PVector getRGB(int c, boolean alpha) {
  return new PVector(getRed(c, alpha), getGreen(c, alpha), getBlue(c, alpha));
}
static class ConstructedImages {
  static class Numbers {
    static final int[][] cero =
    {{0, 3, 3, 0},
     {3, 0, 3, 3},
     {3, 0, 3, 3},
     {3, 0, 3, 3},
     {0, 3, 3, 0}};
    static final int[][] one =
    {{0, 3, 3, 0},
     {3, 3, 3, 0},
     {0, 3, 3, 0},
     {0, 3, 3, 0},
     {3, 3, 3, 3}};
    static final int[][] two =
    {{0, 3, 3, 0},
     {3, 0, 3, 3},
     {0, 0, 3, 3},
     {0, 3, 3, 0},
     {3, 3, 3, 3}};
    static final int[][] three =
    {{3, 3, 3, 0},
     {0, 0, 3, 3},
     {0, 3, 3, 0},
     {0, 0, 3, 3},
     {3, 3, 3, 0}};
    static final int[][] four =
    {{0, 0, 3, 3},
     {0, 3, 0, 3},
     {3, 3, 3, 3},
     {0, 0, 3, 3},
     {0, 0, 3, 3}};
    static final int[][] five =
    {{3, 3, 3, 3},
     {3, 0, 0, 0},
     {0, 3, 3, 3},
     {0, 0, 3, 3},
     {3, 3, 3, 0}};
    static final int[][] six =
    {{0, 3, 3, 0},
     {3, 3, 0, 0},
     {3, 3, 3, 3},
     {3, 3, 0, 3},
     {3, 3, 3, 3}};
    static final int[][] seven =
    {{3, 3, 3, 3},
     {0, 0, 3, 3},
     {0, 0, 3, 3},
     {0, 3, 3, 0},
     {0, 3, 3, 0}};
    static final int[][] eigth =
    {{0, 3, 3, 0},
     {3, 0, 3, 3},
     {0, 3, 3, 0},
     {3, 0, 3, 3},
     {0, 3, 3, 0}};
    static final int[][] nine =
    {{0, 3, 3, 0},
     {3, 0, 3, 3},
     {0, 3, 3, 3},
     {0, 0, 3, 3},
     {0, 0, 3, 3}};
  }

  static final int[][] test =
  {{0, 4, 0, 4, 0},
   {4, 1, 1, 1, 4},
   {4, 1, 4, 1, 4},
   {0, 4, 0, 4, 0}};
}
class Digit {
  int digit;
  String shaderName;
  PShader shader;

  private PVector pixelOffset;

  public PImage[] sprites = new PImage[10];
  public int baseColor = Colors.base;
  public PVector position = new PVector();
  public float scale = 1;

  Digit(int no, String shaderN) {
    for (int i = 0; i < 10; i++) {
      sprites[i] = makePImage(digitImage(i));
    }
    shader = Graphics.getShader(shaderN);
    shaderName = shaderN;
    digit = no < 0 ? 0 : no >= 10 ? 9 : no;

    pixelOffset = new PVector(0.5F / sprites[digit].width, 0.5F / sprites[digit].height);
  }

  public void draw() {
    if (digit >= 10 || digit < 0) return;
    shader(Graphics.getShader("test.frag"));
    shader.set("sprite", sprites[digit]);
    shader.set("spriteSize", (float)sprites[digit].width, (float)sprites[digit].height);
    shader.set("pixelOffset", pixelOffset.x, pixelOffset.y);

    shader.set("baseColor", getRed(baseColor, true), getGreen(baseColor, true), getBlue(baseColor, true), 1 - getAlpha(baseColor));
    shader.set("time", millis() * 0.001F);

    image(sprites[digit], position.x * Graphics.scale, position.y * Graphics.scale,
                  sprites[digit].width * Graphics.scale * scale, sprites[digit].height * Graphics.scale * scale);
  }

  private int[][] digitImage(int no) {
    switch (no) {
      case 0: return ConstructedImages.Numbers.cero;
      case 1: return ConstructedImages.Numbers.one;
      case 2: return ConstructedImages.Numbers.two;
      case 3: return ConstructedImages.Numbers.three;
      case 4: return ConstructedImages.Numbers.four;
      case 5: return ConstructedImages.Numbers.five;
      case 6: return ConstructedImages.Numbers.six;
      case 7: return ConstructedImages.Numbers.seven;
      case 8: return ConstructedImages.Numbers.eigth;
      case 9: return ConstructedImages.Numbers.nine;
      default: return ConstructedImages.Numbers.nine;
    }
  }
}

public int getDigitAtInt(int num, int index) {
  if (index > 0) {
    return (num % (int)pow(10, index + 1)) / (int)pow(10, index);
  } else {
    return num % (int)pow(10, index + 1);
  }
}

public int getDigitAtLong(long num, long index) {
  if (index > 0) {
    return (int)((num % pow(10, index + 1)) / pow(10, index));
  } else {
    return (int)(num % pow(10, index + 1));
  }
}
public class GameObject {
  private String shaderName;
  PShader shader;

  private PVector pixelOffset;

  public PImage sprite;
  public int baseColor = Colors.base;
  public PVector position = new PVector();

  GameObject(int[][] cImage, String shaderN) {
    sprite = makePImage(cImage);
    shader = Graphics.getShader(shaderN);
    shaderName = shaderN;

    pixelOffset = new PVector(0.5F / sprite.width, 0.5F / sprite.height);
  }

  public void draw() {
    shader(Graphics.getShader("test.frag"));
    shader.set("sprite", sprite);
    shader.set("spriteSize", (float)sprite.width, (float)sprite.height);
    shader.set("pixelOffset", pixelOffset.x, pixelOffset.y);

    shader.set("baseColor", getRed(baseColor, true), getGreen(baseColor, true), getBlue(baseColor, true), 1 - getAlpha(baseColor));
    shader.set("time", millis() * 0.001F);

    image(sprite, position.x * Graphics.scale, position.y * Graphics.scale,
                  sprite.width * Graphics.scale, sprite.height * Graphics.scale);
  }
}
public static class Graphics {
  private static ArrayList<PShader> shaders = new ArrayList<PShader>();
  private static IntDict shaderDict = new IntDict();

  public static float scale = pow(2, 2.6f);

  public static void addShader(String name, PShader shader) {
    if (!shaderDict.hasKey(name)) {
      shaderDict.add(name, shaders.size());
      shaders.add(shader);
    }
  }

  public static PShader getShader(String name) {
    if (shaderDict.hasKey(name)) {
      return shaders.get(shaderDict.get(name));
    }
    return null;
  }
}

public PImage makePImage(int[][] ipixels) {
  PImage image = createImage(ipixels[0].length, ipixels.length, ARGB);
  image.loadPixels();
  for (int x = 0; x < image.width; x++) {
    for (int y = 0; y < image.height; y++) {
      image.pixels[y * image.width + x] = getColor(ipixels[y][x]);
    }
  }
  image.updatePixels();
  return image;
}
class Number {
  public long number;

  private float scale = 1;
  private int baseColor = Colors.base;
  private PVector position = new PVector();
  private int dsize;
  private Digit[] digits;

  Number(int number, int size, String shaderN) {
    dsize = abs(size) <= 19 ? abs(size) : 19;
    digits = new Digit[dsize];
    for (int i = 0; i < dsize; i++) {
      digits[i] = new Digit(0, shaderN);
      digits[i].position.x = position.x + (dsize - i) * (digits[i].sprites[0].width + 1) * scale;
      digits[i].position.y = position.y;
    }
  }

  public void setPosition(int x, int y) {
    position.x = x;
    position.y = y;
    for (int i = 0; i < dsize; i++) {
      digits[i].position.x = position.x + (dsize - i - 1) * (digits[i].sprites[0].width + 1) * scale;
      digits[i].position.y = position.y;
    }
  }

  public PVector getPosition() {
    return position;
  }

  public void setScale(float s) {
    scale = s;
    for (int i = 0; i < dsize; i++) {
      digits[i].scale = scale;
      digits[i].position.x = position.x + (dsize - i - 1) * (digits[i].sprites[0].width + 1) * scale;
      digits[i].position.y = position.y;
    }
  }

  public float getScale() {
    return scale;
  }

  public void transform(int x, int y, float s) {
    position.x = x;
    position.y = y;
    scale = s;
    for (int i = 0; i < dsize; i++) {
      digits[i].scale = scale;
      digits[i].position.x = position.x + (dsize - i - 1) * (digits[i].sprites[0].width + 0.5f) * scale;
      digits[i].position.y = position.y;
    }
  }

  public void setBaseColor(int c) {
    baseColor = c;
    for (int i = 0; i < dsize; i++) {
      digits[i].baseColor = baseColor;
    }
  }

  public int getColor() {
    return baseColor;
  }

  public void draw() {
    for (int i = 0; i < dsize; i++) {
      digits[i].draw();
      digits[i].digit = getDigitAtLong(number, i);
    }
  }
}
public static class Time {
  static int mLastDraw = 0;
  private static IntDict timers = new IntDict();
  private static ArrayList<String> names = new ArrayList<String>();
  private static IntDict chronos = new IntDict();

  private static int temp;

  public static int getMS(int millis) {
    return millis - mLastDraw;
  }

  public static void add(String name, int time) {
    if (!timers.hasKey(name)) {
      names.add(name);
      timers.add(name, time);
      chronos.add(name, 0);
    }
  }

  public static int getTimer(String name) {
    return mLastDraw - chronos.get(name);
  }

  public static void update(int millis) {
    mLastDraw = millis;
    for (int i = 0; i < names.size(); i++) {
      temp = mLastDraw - chronos.get(names.get(i));
      if (temp >= timers.get(names.get(i))) {
        chronos.set(names.get(i), mLastDraw);
      }
    }
  }
}
  public void settings() {  size(800, 600, P2D);  noSmooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "OneButtonGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
