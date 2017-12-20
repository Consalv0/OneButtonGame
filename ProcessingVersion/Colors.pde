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
  if (index > Colors.maxIndexValue - Colors.maxIndexValue / 3.3) return Colors.shadow;
  if (index > Colors.maxIndexValue / 3.3) return Colors.midtone;
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
