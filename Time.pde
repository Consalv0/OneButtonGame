public static class Time {
  static int MAXSAMPLES = 100;
  static int mLastDraw = 0;
  static float averageMS = 0;

  private static boolean tickReady;
  private static int tickindex = 0;
  private static int ticksum = 0;
  private static int[] ticklist = new int[MAXSAMPLES];

  private static IntDict timers = new IntDict();
  private static ArrayList<String> names = new ArrayList<String>();
  private static IntDict chronos = new IntDict();

  private static int temp;

  static float delta() {
    return averageMS / 60F;
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

  static float calcAverageTick(int newtick) {
    ticksum -= ticklist[tickindex];  /* subtract value falling off */
    ticksum += newtick;              /* add new value */
    ticklist[tickindex] = newtick;   /* save new value so it can be subtracted later */
    if(++tickindex == MAXSAMPLES) {    /* inc buffer index */
      tickindex = 0; tickReady = true;
    }

    if (!tickReady) return tickindex > 12 ? newtick : 0;

    /* return average */
    return((float)ticksum / MAXSAMPLES);
  }

  static void update(int millis) {
    averageMS = calcAverageTick(millis - mLastDraw);
    mLastDraw = millis;
    for (int i = 0; i < names.size(); i++) {
      temp = mLastDraw - chronos.get(names.get(i));
      if (temp >= timers.get(names.get(i))) {
        chronos.set(names.get(i), mLastDraw);
      }
    }
  }
}
