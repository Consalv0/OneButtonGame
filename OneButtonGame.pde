import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;
import processing.sound.*;

PostFX fx;
GameObject obj, obj2, obj3;
TimeKey[] keys = new TimeKey[KeyTime.KEYSIZE];
TimeBar keyTimeBar;
Number number;
TVPass tvPass;

public void setup(){
  // fullScreen(P2D);
  size(1200, 800, P2D);
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
  for (int i = 0; i < KeyTime.KEYSIZE; i++) {
    keys[i] = new TimeKey(ConstructedImages.downarrow_ON, ConstructedImages.downarrow_OFF, "pixelPerfect.frag", i / KeyTime.KEYSIZE);
    keys[i].scale = 0.5F;
    keys[i].position.y = height - keys[i].height() - keyTimeBar.height();
  }
  obj = new GameObject(ConstructedImages.player, "pixelPerfect.frag");
  obj.scale = 5F;
  obj.speed = 15;
  obj.movement(1, 2);
  obj.position(1000, 200);
  obj.collider(true, true);
  obj2 = new GameObject(ConstructedImages.player, "pixelPerfect.frag");
  obj2.scale = 3F;
  obj2.speed = 30;
  obj2.movement(3, 2);
  obj2.position(900, 10);
  obj2.collider(true, true);
  obj3 = new GameObject(ConstructedImages.player, "pixelPerfect.frag");
  obj3.scale = 8F;
  obj3.speed = 2;
  obj3.movement(1, 1);
  obj3.position(3, 500);
  obj3.collider(true, true);
  number = new Number(10, "pixelPerfect.frag");
  number.scale(1);
  number.baseColor(Colors.highlight);
  number.number = 0;

  Time.add("ScreenSizeUpdate", 200);
  Time.add("Input", 15);
  Time.add("Second", 1000);
}

public void draw() {
  /* Screen has been resized */
  if (Graphics.screenResized) {
    for (int i = 0; i < KeyTime.KEYSIZE; i++) {
      keys[i].timer(map(pow(KeyTime.KEYSIZE - (i + 1), 1.5) / pow(KeyTime.KEYSIZE, 1.5), 0, 1, 0.95, 0));
      keys[i].position.y = height - keys[i].height() - keyTimeBar.height();
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

  tvPass.aberration = tvPass.aberration - 0.1F * Time.delta() <= 0.05F ? 0.05F : tvPass.aberration - 0.1F * Time.delta();

  // if (Time.getTimer("Second") <= 0)
  checkCollisions();

  if (obj.collisions > 0) { Sounds.bounce.play(); tvPass.aberration = 0.3F; number.number = millis(); }
  if ((obj.collisions & CVERTICAL) > 0) { obj.movement(-obj.movement().x, obj.movement().y); }
  if ((obj.collisions & CHORIZONTAL) > 0) { obj.movement(obj.movement().x, -obj.movement().y); }

  if (obj2.collisions > 0) { Sounds.bounce.play(); tvPass.aberration = 0.3F; number.number = millis(); }
  if ((obj2.collisions & CVERTICAL) > 0) { obj2.movement(-obj2.movement().x, obj2.movement().y); }
  if ((obj2.collisions & CHORIZONTAL) > 0) { obj2.movement(obj2.movement().x, -obj2.movement().y); }

  if (obj3.collisions > 0) { Sounds.bounce.play(); tvPass.aberration = 0.3F; number.number = millis(); }
  if ((obj3.collisions & CVERTICAL) > 0) { obj3.movement(-obj3.movement().x, obj3.movement().y); }
  if ((obj3.collisions & CHORIZONTAL) > 0) { obj3.movement(obj3.movement().x, -obj3.movement().y); }

  obj.move();
  obj2.move();
  obj3.move();

  if (mousePressed || keyPressed) {
    // tvPass.aberration = 0F;
    KeyTime.time = (KeyTime.time + 0.05F * Time.delta()) % 1;
  } else {
    KeyTime.time = KeyTime.time - 0.05F * Time.delta() <= 0 ? KeyTime.time : KeyTime.time - 0.05F * Time.delta();
  }
    // obj.position = new PVector(200 * cos(millis() / 500F) + mouseX, 200 * sin(millis() / 500F) + mouseY);
  keyTimeBar.time = KeyTime.time;

  for (int i = 0; i < KeyTime.KEYSIZE; i++) {
    keys[i].draw();
  }
  keyTimeBar.draw();
  obj.draw();
  obj2.draw();
  obj3.draw();
  number.position(width - 15 - number.width(), 20);
  number.draw();

  resetShader();
  // I call the passes, all is declared in the class Graphics
  Graphics.watchScreen(g);
  Graphics.drawPostFX(g, fx, tvPass);

  // Don`t remove this updates the time maybe pause?
  Time.update(millis());
}
