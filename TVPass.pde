class TVPass implements Pass {
  PShader shader;

  public TVPass() {
    shader = Graphics.getShader("fishEye.frag");
  }

  @Override
    public void prepare(Supervisor supervisor) {
      shader.set("barrelD", 1.3F);
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
