import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ch.bildspur.postfx.builder.*; 
import ch.bildspur.postfx.pass.*; 
import ch.bildspur.postfx.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class OneButtonGame extends PApplet {





PostFX fx;
GameObject obj;
Number number;
TVPass tvPass;

public void setup(){
  
  // size(800, 600, P2D);
  surface.setResizable(true);
  frameRate(1000);
  

  fx = new PostFX(this);

  Graphics.addShader("pixelPerfect.frag", loadShader("pixelPerfect.frag"));
  Graphics.addShader("fishEye.frag", loadShader("fishEye.frag"));
  tvPass = new TVPass();

  obj = new GameObject(ConstructedImages.test, "pixelPerfect.frag");
  number = new Number(10, "pixelPerfect.frag");
  obj.scale = 1F;
  obj.position(3, 10);
  number.scale(1);
  number.baseColor(Colors.highlight);
  number.number = 0;

  Time.add("ScreenSizeUpdate", 200);
  Time.add("Input", 15);
  Time.add("QuartSecond", 1000 / 4);
}

public void draw() {
  resetShader();
  background(Colors.dark);
  fill(Colors.base);
  stroke(blendColor(Colors.base, Colors.shadow, MULTIPLY));
  text(width + "x" + height, 10, 20);
  text(frameRate, 8, 35);
  text(Time.getTimer("Input"), 10, 50);
  text(keyCode, 10, 65);
  for (int i = 1; i < 20; i++) {
    line(0, i * height / 20, width, i * height / 20);
    line(i * width / 20, 0, i * width / 20, height);
  }

  if (Time.getTimer("QuartSecond") <= 0)
    number.number = millis();
  if (Time.getTimer("Input") <= 0) {
    obj.position = new PVector(200 * cos(millis() / 500F) + mouseX, 200 * sin(millis() / 500F) + mouseY);
  }

  obj.draw();
  number.position(width - 15 - number.width(), 20);
  number.draw();

  // I call the passes, all is declared in the class Graphics
  Graphics.drawPostFX(g, fx, tvPass);

  // Don`t remove this updates the time maybe pause?
  if (!mousePressed) {
    Time.update(millis());
  }
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
    static final int[][] neg =
    {{0, 0, 0, 0},
     {0, 0, 0, 0},
     {0, 3, 3, 3},
     {0, 3, 3, 3},
     {0, 0, 0, 0}};
  }

  static final int[][] test =
  {{0, 4, 0, 4, 0},
   {4, 1, 1, 1, 4},
   {4, 1, 4, 1, 4},
   {0, 4, 0, 4, 0}};
}
class Digit {
  static final int NEGATIVE = 10;
  int digit;
  String shaderName;
  PShader shader;

  private PVector pixelOffset;

  public PImage[] sprites = new PImage[11];
  public int baseColor = Colors.base;
  public PVector position = new PVector();
  public float scale = 1;

  Digit(int no, String shaderN) {
    for (int i = 0; i < 10; i++) {
      sprites[i] = makePImage(digitImage(i));
    }
    sprites[NEGATIVE] = makePImage(digitImage(NEGATIVE));
    shader = Graphics.getShader(shaderN);
    shaderName = shaderN;
    digit = no < 0 ? 0 : no > 10 ? 9 : no;

    pixelOffset = new PVector(0.5F / sprites[digit].width, 0.5F / sprites[digit].height);
  }

  public void draw() {
    if (digit > 10 || digit < 0) return;
    shader(Graphics.getShader(shaderName));
    shader.set("sprite", sprites[digit]);
    shader.set("spriteSize", (float)sprites[digit].width, (float)sprites[digit].height);
    shader.set("pixelOffset", pixelOffset.x, pixelOffset.y);

    shader.set("baseColor", getRed(baseColor, true), getGreen(baseColor, true), getBlue(baseColor, true), 1 - getAlpha(baseColor));
    shader.set("time", millis() * 0.001F);

    image(sprites[digit], (int)(position.x / Graphics.scale) * Graphics.scale, (int)(position.y / Graphics.scale) * Graphics.scale,
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
      case NEGATIVE: return ConstructedImages.Numbers.neg;
      default: return ConstructedImages.Numbers.cero;
    }
  }
}

public int getDigitAtInt(int num, int index) {
  num = (int)abs(num);
  if (index > 0) {
    return (num % (int)pow(10, index + 1)) / (int)pow(10, index);
  } else {
    return num % (int)pow(10, index + 1);
  }
}

public int getDigitAtLong(long num, long index) {
  num = num <= 0L ? 0L - num : num;
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

  public float scale = 1;
  public PImage sprite;
  public int baseColor = Colors.base;
  private PVector position = new PVector();

  GameObject(int[][] cImage, String shaderN) {
    sprite = makePImage(cImage);
    shader = Graphics.getShader(shaderN);
    shaderName = shaderN;

    pixelOffset = new PVector(0.5F / sprite.width * 1, 0.5F / sprite.height * 1);
  }

  public void position(float x, float y) {
    position.x = x;
    position.y = y;
  }

  public PVector position() {
    return position;
  }

  public void translate(float x, float y) {
    position.x += x;
    position.y += y;
  }

  public void draw() {
    shader(Graphics.getShader(shaderName));
    shader.set("sprite", sprite);
    shader.set("spriteSize", (float)sprite.width, (float)sprite.height);
    shader.set("pixelOffset", pixelOffset.x, pixelOffset.y);

    shader.set("baseColor", getRed(baseColor, true), getGreen(baseColor, true), getBlue(baseColor, true), 1 - getAlpha(baseColor));
    shader.set("time", millis() * 0.001F);

    image(sprite, (int)(position.x / Graphics.scale) * Graphics.scale, (int)(position.y / Graphics.scale) * Graphics.scale,
          sprite.width * Graphics.scale * scale, sprite.height * Graphics.scale * scale);
  }
}
public static class Graphics {
  private static ArrayList<PShader> shaders = new ArrayList<PShader>();
  private static IntDict shaderDict = new IntDict();

  private static int lwidth, lheight;
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

  public static void drawFrame(PGraphics g, int c) {
    g.stroke(c);
    g.line(0, g.height - 1, g.width, g.height - 1);
    g.line(0, 0, 0, g.height - 1);
    g.line(g.width - 1, 0, g.width - 1, g.height);
    g.line(0, 0, g.width - 1, 0);
  }

  public static void drawPostFX(PGraphics g, PostFX fx, Pass pass) {
    g.resetShader();

    if (Time.getTimer("ScreenSizeUpdate") <= 0) {
      if (lwidth != g.width || lheight != g.height) {
        lwidth = g.width;
        lheight = g.height;
        fx.setResolution(g);
      }
    }

    drawFrame(g, blendColor(0xFF444444, 0xFF555555, MULTIPLY)); // Draw the TV Frame

    fx.render()
      .custom(pass)
      // .blur(10, 1.3, true)
      .compose();
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

  Number(int size, String shaderN) {
    dsize = abs(size) <= 19 ? abs(size) : 19;
    digits = new Digit[dsize];
    for (int i = 0; i < dsize; i++) {
      digits[i] = new Digit(0, shaderN);
      digits[i].position.x = position.x + (dsize - i - 1) * (digits[i].sprites[0].width + 1 * (1 / scale)) * Graphics.scale * scale;
      digits[i].position.y = position.y;
    }
  }

  public float width() {
    return dsize * (digits[0].sprites[0].width + 1 * (1 / scale)) * Graphics.scale * scale;
  }

  public void position(float x, float y) {
    position.x = x;
    position.y = y;
    for (int i = 0; i < dsize; i++) {
      digits[i].position.x = position.x + (dsize - i - 1) * (digits[i].sprites[0].width + 1 * (1 / scale)) * Graphics.scale * scale;
      digits[i].position.y = position.y;
    }
  }

  public PVector position() {
    return position;
  }

  public void scale(float s) {
    scale = s;
    for (int i = 0; i < dsize; i++) {
      digits[i].scale = scale;
      digits[i].position.x = position.x + (dsize - i - 1) * (digits[i].sprites[0].width + 1 * (1 / scale)) * Graphics.scale * scale;
      digits[i].position.y = position.y;
    }
  }

  public float scale() {
    return scale;
  }

  public void transform(float x, float y, float s) {
    position.x = x;
    position.y = y;
    scale = s;
    for (int i = 0; i < dsize; i++) {
      digits[i].scale = scale;
      digits[i].position.x = position.x + (dsize - i - 1) * (digits[i].sprites[0].width + 1 * (1 / scale)) * Graphics.scale * scale;
      digits[i].position.y = position.y;
    }
  }

  public void baseColor(int c) {
    baseColor = c;
    for (int i = 0; i < dsize; i++) {
      digits[i].baseColor = baseColor;
    }
  }

  public int baseColor() {
    return baseColor;
  }

  public void draw() {
    if (number < 0) {
      digits[dsize - 1].digit = Digit.NEGATIVE;
    }

    for (int i = 0; i < dsize; i++) {
      digits[i].digit = getDigitAtLong(number, i);
      digits[i].draw();
    }
  }
}
class TVPass implements Pass {
  PShader shader;

  public TVPass() {
    shader = Graphics.getShader("fishEye.frag");
  }

  @Override
    public void prepare(Supervisor supervisor) {
      shader.set("barrelD", 1.3F);
  }

  @Override
    public void apply(Supervisor supervisor) {
    PGraphics pass = supervisor.getNextPass();
    supervisor.clearPass(pass);

    pass.beginDraw();
    pass.shader(shader);
    pass.image(supervisor.getCurrentPass(), 0, 0);
    pass.endDraw();
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
  public void settings() {  fullScreen(P2D);  noSmooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "OneButtonGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
