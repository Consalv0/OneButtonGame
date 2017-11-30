float TIMEWIDTH = 5;
public class TimePoint extends GameObject {
  private float time;
  PImage spriteON, spriteOFF;

  TimePoint(int[][] image_on, int[][] image_off, String shaderN, float t) {
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

  public void draw() {
    shader(Graphics.getShader(shaderName));
    shader.set("sprite", sprite);
    shader.set("spriteSize", (float)sprite.width, (float)sprite.height);
    shader.set("pixelOffset", pixelOffset.x, pixelOffset.y);

    shader.set("baseColor", getRed(baseColor, true), getGreen(baseColor, true), getBlue(baseColor, true), 1 - getAlpha(baseColor));
    // shader.set("time", millis() * 0.001F);
    sprite = KeyTime.time >= time ? spriteON : spriteOFF;
    image(sprite, (int)(position.x / Graphics.scale) * Graphics.scale, (int)(position.y / Graphics.scale) * Graphics.scale,
          sprite.width * Graphics.scale * scale, sprite.height * Graphics.scale * scale);
  }
}
