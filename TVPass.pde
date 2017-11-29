class TVPass implements Pass {
  PShader shader;
  public float barrel = 1.3F;
  public float aberration = 0.08F;

  public TVPass() {
    shader = Graphics.getShader("tvDisort.frag");
  }

  @Override
    public void prepare(Supervisor supervisor) {
      shader.set("barrelD", barrel);
      shader.set("aberration", aberration);
  }

  @Override
    public void apply(Supervisor supervisor) {
    PGraphics pass = supervisor.getNextPass();
    supervisor.clearPass(pass);

    pass.beginDraw();
    pass.shader(shader);
    pass.image(supervisor.getCurrentPass(), 0, 0);
    pass.endDraw();
  }
}
