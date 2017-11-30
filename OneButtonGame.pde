import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;
import processing.sound.*;

PostFX fx;
GameObject obj;
TimePoint[] tPoints = new TimePoint[4];
TimeBar keyTimeBar;
Number number;
TVPass tvPass;

public void setup(){
  // fullScreen(P2D);
  size(800, 600, P2D);
  surface.setResizable(true);
  frameRate(1000);
  noSmooth();

  fx = new PostFX(this);
  Sounds.initialize(this);

  Graphics.addShader("pixelPerfect.frag", loadShader("pixelPerfect.frag"));
  Graphics.addShader("tvDisort.frag", loadShader("tvDisort.frag"));
  tvPass = new TVPass();

  keyTimeBar = new TimeBar(ConstructedImages.timerLine_ON, ConstructedImages.timerLine_OFF, "pixelPerfect.frag");
  keyTimeBar.scale = 0.5F;
  keyTimeBar.position.y = height - keyTimeBar.height();
  for (int i = 0; i < 4; i++) {
    tPoints[i] = new TimePoint(ConstructedImages.downarrow_ON, ConstructedImages.downarrow_OFF, "pixelPerfect.frag", 0);
    tPoints[i].scale = 0.5F;
    tPoints[i].position.y = height - tPoints[i].height() - keyTimeBar.height();
  }
  obj = new GameObject(ConstructedImages.player, "pixelPerfect.frag");
  number = new Number(10, "pixelPerfect.frag");
  obj.scale = 1F;
  obj.speed = 30;
  obj.movement(1, 2);
  obj.position(3, 10);
  number.scale(1);
  number.baseColor(Colors.highlight);
  number.number = 0;

  Time.add("ScreenSizeUpdate", 200);
  Time.add("Input", 15);
  Time.add("Second", 1000);
}

public void draw() {
  /* Screen has resized */
  if (Graphics.screenResized) {
    for (int i = 0; i < 4; i++) {
      tPoints[i].timer(((i + 1) / 4.5F) + 0.07F);
      tPoints[i].position.y = height - tPoints[i].height() - keyTimeBar.height();
    }
    keyTimeBar.position.y = height - keyTimeBar.height();
  }

  resetShader();
  background(Colors.dark);
  fill(Colors.base);
  text(width + "x" + height, 10, 20);
  text(frameRate, 8, 35);
  text(Time.delta(), 10, 50);
  text(KeyTime.time, 10, 65);
  // stroke(blendColor(Colors.base, Colors.shadow, MULTIPLY));
  // for (int i = 1; i < 20; i++) {
  //   line(0, i * height / 20, width, i * height / 20);
  //   line(i * width / 20, 0, i * width / 20, height);
  // }

  if (!mousePressed) {
    tvPass.aberration = tvPass.aberration - 0.1F * Time.delta() <= 0.08F ? 0.08F : tvPass.aberration - 0.1F * Time.delta();
  } else {
    tvPass.aberration = 0F;
  }

  // if (Time.getTimer("Second") <= 0)
  obj.move();
  if (obj.collisions > 0) { Sounds.bounce.play(); tvPass.aberration += 0.4F; number.number = millis(); }
  if ((obj.collisions & CVERTICAL) > 0) obj.movement(-obj.movement().x, obj.movement().y);
  if ((obj.collisions & CHORIZONTAL) > 0) obj.movement(obj.movement().x, -obj.movement().y);

  if (Time.getTimer("Input") <= 0) {
    if (mousePressed) {
      KeyTime.time = (KeyTime.time + 0.1F * Time.delta()) % 1;
    } else {
      KeyTime.time = KeyTime.time - 0.1F * Time.delta() <= 0 ? KeyTime.time : KeyTime.time - 0.1F * Time.delta();
    }
    // obj.position = new PVector(200 * cos(millis() / 500F) + mouseX, 200 * sin(millis() / 500F) + mouseY);
  }
  keyTimeBar.time = KeyTime.time;

  for (int i = 0; i < 4; i++) {
    tPoints[i].draw();
  }
  keyTimeBar.draw();
  obj.draw();
  number.position(width - 15 - number.width(), 20);
  number.draw();

  // I call the passes, all is declared in the class Graphics
  Graphics.watchScreen(g);
  Graphics.drawPostFX(g, fx, tvPass);

  // Don`t remove this updates the time maybe pause?
  Time.update(millis());
}
