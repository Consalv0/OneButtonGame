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
