
PImage makePImage(int[][] ipixels) {
  PImage image = createImage(ipixels[0].length, ipixels.length, ARGB);
  image.loadPixels();
  for (int x = 0; x < image.width; x++) {
    for (int y = 0; y < image.height; y++) {
      image.pixels[y * image.width + x] = getColor(ipixels[y][x]);
    }
  }
  image.updatePixels();
  return image;
}
