import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

PostFX fx;
GameObject obj;
Number number;
TVPass tvPass;
int lwidth, lheight;

public void setup(){
  // fullScreen(P2D);
  size(800, 600, P2D);
  surface.setResizable(true);
  frameRate(1000);
  noSmooth();

  fx = new PostFX(this);

  Graphics.addShader("pixelPerfect.frag", loadShader("pixelPerfect.frag"));
  Graphics.addShader("fishEye.frag", loadShader("fishEye.frag"));
  tvPass = new TVPass();

  obj = new GameObject(ConstructedImages.test, "pixelPerfect.frag");
  number = new Number(10, "pixelPerfect.frag");
  obj.scale = 1F;
  obj.position(3, 10);
  number.scale(1);
  number.baseColor(Colors.highlight);
  number.number = 0;

  Time.add("ScreenSizeUpdate", 200);
  Time.add("Input", 15);
  Time.add("QuartSecond", 1000 / 4);
}

public void draw() {
  resetShader();
  background(Colors.dark);
  fill(Colors.base);
  text(width + "x" + height, 10, 20);
  text(frameRate, 8, 35);
  text(Time.getTimer("Input"), 10, 50);
  text(keyCode, 10, 65);

  if (Time.getTimer("QuartSecond") <= 0)
    number.number = millis();
  if (mousePressed && Time.getTimer("Input") <= 0) {

  }
  obj.position = new PVector(200 * cos(millis() / 500F) + width / 2F, 200 * sin(millis() / 500F) + height / 2F);

  obj.draw();
  number.position(width - 15 - number.width(), 20);
  number.draw();

  drawPostFX();

  Time.update(millis());
}
