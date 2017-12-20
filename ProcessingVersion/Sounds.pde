public static class Sounds {
  static SoundFile bounce;
  static SoundFile keyActive;

  static void initialize(PApplet applet) {
    bounce = new SoundFile(applet, "pi.wav");
    keyActive = new SoundFile(applet, "pshp.wav");
  }
}
