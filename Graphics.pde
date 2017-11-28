public static class Graphics {
  private static ArrayList<PShader> shaders = new ArrayList<PShader>();
  private static IntDict shaderDict = new IntDict();

  private static int lwidth, lheight;
  public static float scale = pow(2, 2.6);

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

  static void drawPostFX(PGraphics g, PostFX fx, Pass pass) {
    g.resetShader();

    if (Time.getTimer("ScreenSizeUpdate") <= 0) {
      if (lwidth != g.width || lheight != g.height) {
        lwidth = g.width;
        lheight = g.height;
        fx.setResolution(g);
      }
    }

    fx.render()
      .custom(pass)
      .blur(10, 1.3, true)
      .compose();
    // image(g, 0, 0);
  }
}
