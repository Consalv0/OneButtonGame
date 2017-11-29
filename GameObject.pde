public class GameObject {
  private String shaderName;
  PShader shader;

  private PVector pixelOffset;

  public PImage sprite;
  private float width;
  public int baseColor = Colors.base;

  public float scale = 1;
  public float speed = 0;
  private PVector position = new PVector();
  private PVector movement = new PVector();

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
    translate(movement.x * speed, movement.y * speed);
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
