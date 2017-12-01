import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ch.bildspur.postfx.builder.*; 
import ch.bildspur.postfx.pass.*; 
import ch.bildspur.postfx.*; 
import processing.sound.*; 

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
GameObject obj, obj2;
TimeKey[] keys = new TimeKey[KeyTime.KEYSIZE];
TimeBar keyTimeBar;
Number number;
TVPass tvPass;

public void setup(){
  // fullScreen(P2D);
  
  surface.setResizable(true);
  frameRate(1000);
  

  fx = new PostFX(this);
  Sounds.initialize(this);

  Graphics.addShader("pixelPerfect.frag", loadShader("pixelPerfect.frag"));
  Graphics.addShader("tvDisort.frag", loadShader("tvDisort.frag"));
  tvPass = new TVPass();

  keyTimeBar = new TimeBar(ConstructedImages.timerLine_ON, ConstructedImages.timerLine_OFF, "pixelPerfect.frag");
  keyTimeBar.scale = 0.5F;
  keyTimeBar.position.y = height - keyTimeBar.height();
  for (int i = 0; i < KeyTime.KEYSIZE; i++) {
    keys[i] = new TimeKey(ConstructedImages.downarrow_ON, ConstructedImages.downarrow_OFF, "pixelPerfect.frag", i / KeyTime.KEYSIZE);
    keys[i].scale = 0.5F;
    keys[i].position.y = height - keys[i].height() - keyTimeBar.height();
  }
  obj = new GameObject(ConstructedImages.player, "pixelPerfect.frag");
  obj.scale = 1F;
  obj.speed = 30;
  obj.movement(1, 2);
  obj.position(3, 10);
  obj.collider(true, true);
  obj2 = new GameObject(ConstructedImages.player, "pixelPerfect.frag");
  obj2.scale = 1F;
  obj2.speed = 30;
  obj2.movement(3, 2);
  obj2.position(100, 10);
  obj2.collider(true, true);
  number = new Number(10, "pixelPerfect.frag");
  number.scale(1);
  number.baseColor(Colors.highlight);
  number.number = 0;

  Time.add("ScreenSizeUpdate", 200);
  Time.add("Input", 15);
  Time.add("Second", 1000);
}

public void draw() {
  /* Screen has been resized */
  if (Graphics.screenResized) {
    for (int i = 0; i < KeyTime.KEYSIZE; i++) {
      keys[i].timer(map(pow(KeyTime.KEYSIZE - (i + 1), 1.5f) / pow(KeyTime.KEYSIZE, 1.5f), 0, 1, 0.95f, 0));
      keys[i].position.y = height - keys[i].height() - keyTimeBar.height();
    }
    keyTimeBar.position.y = height - keyTimeBar.height();
  }

  resetShader();
  background(Colors.dark);
  fill(Colors.base);
  text(width + "x" + height, 10, 20);
  text(frameRate, 8, 35);
  text(Time.delta(), 10, 50);
  text(KeyTime.time, 10, 65);
  // stroke(blendColor(Colors.base, Colors.shadow, MULTIPLY));
  // for (int i = 1; i < 20; i++) {
  //   line(0, i * height / 20, width, i * height / 20);
  //   line(i * width / 20, 0, i * width / 20, height);
  // }

  tvPass.aberration = tvPass.aberration - 0.1F * Time.delta() <= 0.05F ? 0.05F : tvPass.aberration - 0.1F * Time.delta();

  // if (Time.getTimer("Second") <= 0)
  checkCollisions();

  if (obj.collisions > 0) { Sounds.bounce.play(); tvPass.aberration = 0.3F; number.number = millis(); }
  if ((obj.collisions & CVERTICAL) > 0) { obj.movement(-obj.movement().x, obj.movement().y); }
  if ((obj.collisions & CHORIZONTAL) > 0) { obj.movement(obj.movement().x, -obj.movement().y); }

  if (obj2.collisions > 0) { Sounds.bounce.play(); tvPass.aberration = 0.3F; number.number = millis(); }
  if ((obj2.collisions & CVERTICAL) > 0) { obj2.movement(-obj2.movement().x, obj2.movement().y); }
  if ((obj2.collisions & CHORIZONTAL) > 0) { obj2.movement(obj2.movement().x, -obj2.movement().y); }

  obj.move();
  obj2.move();

  if (mousePressed || keyPressed) {
    // tvPass.aberration = 0F;
    KeyTime.time = (KeyTime.time + 0.05F * Time.delta()) % 1;
  } else {
    KeyTime.time = KeyTime.time - 0.05F * Time.delta() <= 0 ? KeyTime.time : KeyTime.time - 0.05F * Time.delta();
  }
    // obj.position = new PVector(200 * cos(millis() / 500F) + mouseX, 200 * sin(millis() / 500F) + mouseY);
  keyTimeBar.time = KeyTime.time;

  for (int i = 0; i < KeyTime.KEYSIZE; i++) {
    keys[i].draw();
  }
  keyTimeBar.draw();
  obj.draw();
  obj2.draw();
  number.position(width - 15 - number.width(), 20);
  number.draw();

  // I call the passes, all is declared in the class Graphics
  Graphics.watchScreen(g);
  Graphics.drawPostFX(g, fx, tvPass);

  // Don`t remove this updates the time maybe pause?
  Time.update(millis());
}
/* Collision Flags */
final int CTOP = 2;
final int CDOWN = 4;
final int CLEFT = 8;
final int CRIGHT = 16;
final int CHORIZONTAL = CTOP | CDOWN;
final int CVERTICAL = CLEFT | CRIGHT;

ArrayList<GameObject> rectColliders = new ArrayList<GameObject>();

public void checkCollisions() {
  for (int i = 0; i < rectColliders.size(); i++) { rectColliders.get(i).collisions = 0; }

  float w, h, ow, oh;
  GameObject actual, other;
  int collisions = 0;
  for (int i = 0; i < rectColliders.size(); i++) {
    actual = rectColliders.get(i);
    w = actual.width();
    h = actual.height();

    collisions = 0;

    if (actual.collideWithBorders) {
      /* Border Collisions */
      if (actual.position.x < 0)                collisions |= CLEFT;
      else if (actual.position.x + w > width)   collisions |= CRIGHT;
      else if (actual.position.y < 0)           collisions |= CTOP;
      else if (actual.position.y + h > height)  collisions |= CDOWN;
      if (collisions > 0) {
        actual.collisions |= collisions;
        actual.onBorderCollision(collisions);
      }
      /* Clamp Position (prevents multiple collisions) */
      actual.position.x = actual.position.x + w >= width ? actual.position.x - Graphics.scale * actual.scale :
        actual.position.x <= 0 ? actual.position.x + Graphics.scale * actual.scale : actual.position.x;
      actual.position.y = actual.position.y + h >= height ? actual.position.y - Graphics.scale * actual.scale :
        actual.position.y <= 0 ? actual.position.y + Graphics.scale * actual.scale : actual.position.y;
    }

    /* Other rects colliders collisions */
    for (int j = i + 1; j < rectColliders.size(); j++) {
      other = rectColliders.get(j);
      ow = other.width();
      oh = other.height();

      if (actual.position.x < other.position.x + ow && actual.position.x > other.position.x - ow / 2) {
        if (!(actual.position.y > other.position.y + oh || actual.position.y + h < other.position.y)) {
          other.collisions |= CRIGHT;
          actual.collisions |= CLEFT;
          actual.onCollision(other); other.onCollision(actual);
        }
      }
      if (actual.position.x + w > other.position.x && actual.position.x + w < other.position.x + ow / 2) {
        if (!(actual.position.y > other.position.y + oh || actual.position.y + h < other.position.y)) {
          other.collisions |= CLEFT;
          actual.collisions |= CRIGHT;
          actual.onCollision(other); other.onCollision(actual);
        }
      }
      if (actual.position.y < other.position.y + oh && actual.position.y > other.position.y - oh / 2) {
        if (!(actual.position.x > other.position.x + ow || actual.position.x + w < other.position.x)) {
          other.collisions |= CTOP;
          actual.collisions |= CDOWN;
          actual.onCollision(other); other.onCollision(actual);
        }
      }
      if (actual.position.y + h > other.position.y && actual.position.y + h < other.position.y + oh / 2) {
        if (!(actual.position.x > other.position.x + ow || actual.position.x + w < other.position.x)) {
          other.collisions |= CTOP;
          actual.collisions |= CDOWN;
          actual.onCollision(other); other.onCollision(actual);
        }
      }
    }
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
    static final int[][] zero =
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

  static final int[][] timerLine_ON =
  {{1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1}};

  static final int[][] timerLine_OFF =
   {{4, 4, 4, 4, 4},
    {4, 4, 4, 4, 4},
    {4, 4, 4, 4, 4}};

  static final int[][] player =
  {{0, 4, 0, 4, 0},
   {4, 1, 1, 1, 4},
   {4, 1, 4, 1, 4},
   {0, 4, 0, 4, 0}};

  static final int[][] downarrow_ON =
  {{1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1},
   {0, 1, 1, 1, 0},
   {0, 0, 1, 0, 0}};

  static final int[][] downarrow_OFF =
  {{5, 5, 5, 5, 5},
   {5, 5, 5, 5, 5},
   {0, 5, 5, 5, 0},
   {0, 0, 5, 0, 0}};
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
    // shader.set("time", millis() * 0.001F);

    image(sprites[digit], (int)(position.x / Graphics.scale) * Graphics.scale, (int)(position.y / Graphics.scale) * Graphics.scale,
          sprites[digit].width * Graphics.scale * scale, sprites[digit].height * Graphics.scale * scale);
  }

  private int[][] digitImage(int no) {
    switch (no) {
      case 0: return ConstructedImages.Numbers.zero;
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
      default: return ConstructedImages.Numbers.neg;
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
  protected String shaderName;
  PShader shader;

  protected PVector pixelOffset;

  int collisions = 0;
  protected boolean isCollider = false;
  boolean collideWithBorders = false;

  public PImage sprite;
  public int baseColor = Colors.base;

  public float scale = 1;
  public float speed = 0;
  protected PVector position = new PVector();
  protected PVector movement = new PVector();

  GameObject() {}
  GameObject(int[][] cImage, String shaderN) {
    sprite = makePImage(cImage);
    shader = Graphics.getShader(shaderN);
    shaderName = shaderN;

    pixelOffset = new PVector(0.5F / sprite.width * 1, 0.5F / sprite.height * 1);
  }

  public void collider(boolean option, boolean borders) {
    collider(option);
    collideWithBorders = borders;
  }
  public void collider(boolean option) {
    if (option && !isCollider) {
      rectColliders.add(this);
      isCollider = true;
    } else if (!option && isCollider) {
      rectColliders.remove(this);
      isCollider = false;
    }
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

  public void movement(float x, float y) {
    movement.x = x;
    movement.y = y;
    movement.normalize();
  }
  public PVector movement(PVector v) {
    v.normalize();
    movement = v;
    return movement;
  }

  public PVector movement() {
    return movement;
  }

  public float width() {
    return sprite.width * scale * Graphics.scale;
  }
  public float height() {
    return sprite.height * scale * Graphics.scale;
  }

  public void move() {
    translate(movement.x * speed * Time.delta(), movement.y * speed * Time.delta());
    // println(movement.x * speed * 1F / Time.getFPS());
  }

  public void onBorderCollision(int sides) {

  }

  public void onCollision(GameObject other) {

  }

  public void draw() {
    shader(Graphics.getShader(shaderName));
    shader.set("sprite", sprite);
    shader.set("spriteSize", (float)sprite.width, (float)sprite.height);
    shader.set("pixelOffset", pixelOffset.x, pixelOffset.y);

    shader.set("baseColor", getRed(baseColor, true), getGreen(baseColor, true), getBlue(baseColor, true), 1 - getAlpha(baseColor));
    // shader.set("time", millis() * 0.001F);

    image(sprite, (int)(position.x / Graphics.scale) * Graphics.scale, (int)(position.y / Graphics.scale) * Graphics.scale,
          sprite.width * Graphics.scale * scale, sprite.height * Graphics.scale * scale);
  }
}
public static class Graphics {
  private static ArrayList<PShader> shaders = new ArrayList<PShader>();
  private static IntDict shaderDict = new IntDict();

  private static int lwidth, lheight;
  public static float scale = pow(2, 2.6f);
  public static boolean screenResized = true;

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

  public static void watchScreen(PGraphics g) {
    if (Time.getTimer("ScreenSizeUpdate") <= 0) {
      if (lwidth != g.width || lheight != g.height) {
        lwidth = g.width;
        lheight = g.height;
        screenResized = true;
        return;
      }
    }
    screenResized = false;
  }

  public static void drawPostFX(PGraphics g, PostFX fx, Pass pass) {
    g.resetShader();
    if (screenResized) fx.setResolution(g);
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
static class KeyTime {
  static final int KEYSIZE = 4;
  static float time = 0;
  static int activeTimePoint;
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
public static class Sounds {
  static SoundFile bounce;
  static SoundFile keyActive;

  public static void initialize(PApplet applet) {
    bounce = new SoundFile(applet, "pi.wav");
    keyActive = new SoundFile(applet, "pshp.wav");
  }
}
class TVPass implements Pass {
  PShader shader;
  public float barrel = 1.4F;
  public float aberration = 0.08F;

  public TVPass() {
    shader = Graphics.getShader("tvDisort.frag");
  }

  @Override
    public void prepare(Supervisor supervisor) {
      shader.set("barrelD", barrel);
      shader.set("aberration", aberration);
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
  static int MAXSAMPLES = 100;
  static int mLastDraw = 0;
  static float averageMS = 0;

  private static boolean tickReady;
  private static int tickindex = 0;
  private static int ticksum = 0;
  private static int[] ticklist = new int[MAXSAMPLES];

  private static IntDict timers = new IntDict();
  private static ArrayList<String> names = new ArrayList<String>();
  private static IntDict chronos = new IntDict();

  private static int temp;

  public static float delta() {
    return averageMS / 60F;
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

  public static float calcAverageTick(int newtick) {
    ticksum -= ticklist[tickindex];  /* subtract value falling off */
    ticksum += newtick;              /* add new value */
    ticklist[tickindex] = newtick;   /* save new value so it can be subtracted later */
    if(++tickindex == MAXSAMPLES) {    /* inc buffer index */
      tickindex = 0; tickReady = true;
    }

    if (!tickReady) return tickindex > 12 ? newtick : 0;

    /* return average */
    return((float)ticksum / MAXSAMPLES);
  }

  public static void update(int millis) {
    averageMS = calcAverageTick(millis - mLastDraw);
    mLastDraw = millis;
    for (int i = 0; i < names.size(); i++) {
      temp = mLastDraw - chronos.get(names.get(i));
      if (temp >= timers.get(names.get(i))) {
        chronos.set(names.get(i), mLastDraw);
      }
    }
  }
}
class TimeBar extends GameObject {
  PImage spriteON, spriteOFF;
  float time;

  TimeBar(int[][] image_on, int[][] image_off, String shaderN) {
    spriteON = makePImage(image_on);
    spriteOFF = makePImage(image_off);
    sprite = spriteON;

    shader = Graphics.getShader(shaderN);
    shaderName = shaderN;
    time = 0;

    pixelOffset = new PVector(0.5F / sprite.width, 0.5F / sprite.height);
  }

  public void draw() {
    shader(Graphics.getShader(shaderName));
    shader.set("sprite", spriteOFF);
    shader.set("spriteSize", (float)width, (float)spriteOFF.height);
    shader.set("pixelOffset", pixelOffset.x, pixelOffset.y);

    shader.set("baseColor", getRed(baseColor, true), getGreen(baseColor, true), getBlue(baseColor, true), 1 - getAlpha(baseColor));
    // shader.set("time", millis() * 0.001F);

    image(spriteOFF, (int)(position.x / Graphics.scale) * Graphics.scale, (int)(position.y / Graphics.scale) * Graphics.scale,
          width * Graphics.scale * scale, sprite.height * Graphics.scale * scale);

    shader(Graphics.getShader(shaderName));
    shader.set("sprite", spriteON);
    shader.set("spriteSize", width * time, (float)spriteON.height);
    shader.set("pixelOffset", 0.5F / sprite.width * time, pixelOffset.y);

    shader.set("baseColor", getRed(baseColor, true), getGreen(baseColor, true), getBlue(baseColor, true), 1 - getAlpha(baseColor));

    image(spriteON, (int)(position.x / Graphics.scale) * Graphics.scale, (int)(position.y / Graphics.scale) * Graphics.scale,
          width * time, sprite.height * Graphics.scale * scale);
  }
}
public class TimeKey extends GameObject {
  private float time;
  public boolean active;
  PImage spriteON, spriteOFF;

  TimeKey(int[][] image_on, int[][] image_off, String shaderN, float t) {
    spriteON = makePImage(image_on);
    spriteOFF = makePImage(image_off);
    sprite = spriteON;

    shader = Graphics.getShader(shaderN);
    shaderName = shaderN;
    timer(t);

    pixelOffset = new PVector(0.5F / sprite.width * 1, 0.5F / sprite.height * 1);
  }

  public void timer(float t) {
    time = t;
    position.x = time * width - width() / 2;
  }

  public void playSound() {
    if (!active && KeyTime.time >= time) {
      Sounds.keyActive.play(time, 0.25F);
    }
  }

  public void draw() {
    shader(Graphics.getShader(shaderName));
    shader.set("sprite", sprite);
    shader.set("spriteSize", (float)sprite.width, (float)sprite.height);
    shader.set("pixelOffset", pixelOffset.x, pixelOffset.y);

    shader.set("baseColor", getRed(baseColor, true), getGreen(baseColor, true), getBlue(baseColor, true), 1 - getAlpha(baseColor));
    // shader.set("time", millis() * 0.001F);

    playSound();
    active = KeyTime.time >= time;
    sprite = active ? spriteON : spriteOFF;
    image(sprite, (int)(position.x / Graphics.scale) * Graphics.scale, (int)(position.y / Graphics.scale) * Graphics.scale,
          sprite.width * Graphics.scale * scale, sprite.height * Graphics.scale * scale);
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
