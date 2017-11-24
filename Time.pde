public static class Time {
  static int mLastDraw = 0;
  private static IntDict timers = new IntDict();
  private static ArrayList<String> names = new ArrayList<String>();
  private static IntDict chronos = new IntDict();

  private static int temp;

  static int getMS(int millis) {
    return millis - mLastDraw;
  }

  static void add(String name, int time) {
    if (!timers.hasKey(name)) {
      names.add(name);
      timers.add(name, time);
      chronos.add(name, 0);
    }
  }

  static int getTimer(String name) {
    return mLastDraw - chronos.get(name);
  }

  static void update(int millis) {
    mLastDraw = millis;
    for (int i = 0; i < names.size(); i++) {
      temp = mLastDraw - chronos.get(names.get(i));
      if (temp >= timers.get(names.get(i))) {
        chronos.set(names.get(i), mLastDraw);
      }
    }
  }
}
