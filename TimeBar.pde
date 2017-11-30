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

    pixelOffset = new PVector(0.5F / sprite.width * 1, 0.5F / sprite.height * 1);
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
    shader.set("pixelOffset", pixelOffset.x, pixelOffset.y);

    shader.set("baseColor", getRed(baseColor, true), getGreen(baseColor, true), getBlue(baseColor, true), 1 - getAlpha(baseColor));

    image(spriteON, (int)(position.x / Graphics.scale) * Graphics.scale, (int)(position.y / Graphics.scale) * Graphics.scale,
          width * time, sprite.height * Graphics.scale * scale);
  }
}
