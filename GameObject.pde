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
