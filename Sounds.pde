public static class Sounds {
  static SoundFile bounce;

  static void initialize(PApplet applet) {
    bounce = new SoundFile(applet, "pi.wav");
  }
}
