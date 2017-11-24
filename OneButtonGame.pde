// PGraphics pg;
PShader testShader;
GameObject obj;
Number number;

public void setup(){
  // fullScreen(P2D);
  size(800, 600, P2D);
  surface.setResizable(true);
  frameRate(1000);
  noSmooth();

  Graphics.addShader("test.frag", loadShader("test.frag"));
  obj = new GameObject(ConstructedImages.test, "test.frag");
  number = new Number(0, 40, "test.frag");
  obj.position = new PVector(3, 10);
  number.transform(10, 20, 0.5);
  number.setBaseColor(Colors.highlight);
  number.number = 1;
  Time.add("Input", 15);
  Time.add("Second", 1000);
}

public void draw(){
  resetShader();
  background(Colors.dark);
  fill(Colors.base);
  text(width + "x" + height, 10, 20);
  text(frameRate, 8, 35);
  text(Time.getTimer("Input"), 10, 50);
  text(keyCode, 10, 65);

  if (Time.getTimer("Second") <= 0)
    number.number++;
  if (keyPressed && Time.getTimer("Input") <= 0) {
    obj.position.y += key == 's' ? 1 : key == 'w' ? -1 : 0;
    obj.position.x += key == 'd' ? 1 : key == 'a' ? -1 : 0;
  }
  number.setPosition((int)(mouseX / Graphics.scale), (int)(mouseY / Graphics.scale));
  obj.draw();
  number.draw();

  Time.update(millis());
}
