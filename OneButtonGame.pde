import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

PostFX fx;
GameObject obj;
Number number;
TVPass tvPass;

public void setup(){
  // fullScreen(P2D);
  size(800, 600, P2D);
  surface.setResizable(true);
  frameRate(1000);
  noSmooth();

  fx = new PostFX(this);

  Graphics.addShader("pixelPerfect.frag", loadShader("pixelPerfect.frag"));
  Graphics.addShader("tvDisort.frag", loadShader("tvDisort.frag"));
  tvPass = new TVPass();

  obj = new GameObject(ConstructedImages.test, "pixelPerfect.frag");
  number = new Number(10, "pixelPerfect.frag");
  obj.scale = 1F;
  obj.speed = 15;
  obj.movement(1, 2);
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
  // stroke(blendColor(Colors.base, Colors.shadow, MULTIPLY));
  // for (int i = 1; i < 20; i++) {
  //   line(0, i * height / 20, width, i * height / 20);
  //   line(i * width / 20, 0, i * width / 20, height);
  // }

  if (!mousePressed) {
    if (Time.getTimer("Input") <= 0)
    tvPass.aberration = tvPass.aberration - 0.05F <= 0.08F ? 0.08F : tvPass.aberration - 0.05F;
  } else {
    tvPass.aberration = 0.4F;
  }

  if (Time.getTimer("QuartSecond") <= 0)
    number.number = millis();
  if (Time.getTimer("Input") <= 0) {
    obj.move();
    if (obj.position.x < 0 || obj.position.x + obj.width() > width) { obj.movement(-obj.movement().x, obj.movement().y); tvPass.aberration += 0.4F; }
    if (obj.position.y < 0 || obj.position.y + obj.height() > height) { obj.movement(obj.movement().x, -obj.movement().y); tvPass.aberration += 0.4F; }
    // obj.position = new PVector(200 * cos(millis() / 500F) + mouseX, 200 * sin(millis() / 500F) + mouseY);
  }

  obj.draw();
  number.position(width - 15 - number.width(), 20);
  number.draw();

  // I call the passes, all is declared in the class Graphics
  Graphics.drawPostFX(g, fx, tvPass);

  // Don`t remove this updates the time maybe pause?
  Time.update(millis());
}
