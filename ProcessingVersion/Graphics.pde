public static class Graphics {
  private static ArrayList<PShader> shaders = new ArrayList<PShader>();
  private static IntDict shaderDict = new IntDict();

  private static int lwidth, lheight;
  public static float scale = pow(2, 2.6);
  public static boolean screenResized = true;

  public static void addShader(String name, PShader shader) {
    if (!shaderDict.hasKey(name)) {
      shaderDict.add(name, shaders.size());
      shaders.add(shader);
    }
  }

  public static PShader getShader(String name) {
    if (shaderDict.hasKey(name)) {
      return shaders.get(shaderDict.get(name));
    }
    return null;
  }

  static void drawFrame(PGraphics g, int c) {
    g.stroke(c);
    g.line(0, g.height - 1, g.width, g.height - 1);
    g.line(0, 0, 0, g.height - 1);
    g.line(g.width - 1, 0, g.width - 1, g.height);
    g.line(0, 0, g.width - 1, 0);
  }

  static void watchScreen(PGraphics g) {
    if (Time.getTimer("ScreenSizeUpdate") <= 0) {
      if (lwidth != g.width || lheight != g.height) {
        lwidth = g.width;
        lheight = g.height;
        screenResized = true;
        return;
      }
    }
    screenResized = false;
  }

  static void drawPostFX(PGraphics g, PostFX fx, Pass pass) {
    g.resetShader();
    if (screenResized) fx.setResolution(g);
    drawFrame(g, blendColor(0xFF444444, 0xFF555555, MULTIPLY)); // Draw the TV Frame

    fx.render()
      .custom(pass)
      // .blur(10, 1.3, true)
      .compose();
  }
}
