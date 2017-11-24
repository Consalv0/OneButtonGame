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
      digits[i].position.x = position.x + (dsize - i - 1) * (digits[i].sprites[0].width + 0.5) * scale;
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
