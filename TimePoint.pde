float TIMEWIDTH = 5;
public class TimePoint extends GameObject {
  private float time;

  TimePoint(int[][] cImage, String shaderN, float t) {
    sprite = makePImage(cImage);
    shader = Graphics.getShader(shaderN);
    shaderName = shaderN;
    timer(t);

    pixelOffset = new PVector(0.5F / sprite.width * 1, 0.5F / sprite.height * 1);
  }

  public void timer(float t) {
    time = t;
    position.x = time * width;
    position.y = height - height() - TIMEWIDTH - 1;
  }
}
