private class Number extends GameObject {
  public long number;

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
  public float height() {
    return digits[0].sprites[0].height * Graphics.scale * scale;
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

  public void translate(float x, float y) {
    position.x += x;
    position.y += y;
    for (int i = 0; i < dsize; i++) {
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
