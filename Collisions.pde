/* Collision Flags */
final int CTOP = 2;
final int CDOWN = 4;
final int CLEFT = 8;
final int CRIGHT = 16;
final int CHORIZONTAL = CTOP | CDOWN;
final int CVERTICAL = CLEFT | CRIGHT;

ArrayList<GameObject> rectColliders = new ArrayList<GameObject>();

void checkCollisions() {
  /* Clear Collisions */
  for (int i = 0; i < rectColliders.size(); i++) { rectColliders.get(i).collisions = 0; }

  float w, h, ow, oh, dx, dy;
  GameObject actual, other;
  int collisions = 0;

  for (int i = 0; i < rectColliders.size(); i++) {
    actual = rectColliders.get(i);
    w = actual.width();
    h = actual.height();

    collisions = 0;

    if (actual.collideWithBorders) {
      /* Border Collisions */
      if (actual.position.x < 0)                collisions |= CLEFT;
      else if (actual.position.x + w > width)   collisions |= CRIGHT;
      else if (actual.position.y < 0)           collisions |= CTOP;
      else if (actual.position.y + h > height)  collisions |= CDOWN;
      if (collisions > 0) {
        actual.collisions |= collisions;
        actual.onBorderCollision(collisions);
      }
      /* Clamp Position (prevents multiple collisions) */
      actual.position.x = actual.position.x + w >= width ? actual.position.x - Graphics.scale * actual.scale / 10 :
        actual.position.x <= 0 ? actual.position.x + Graphics.scale * actual.scale / 10 : actual.position.x;
      actual.position.y = actual.position.y + h >= height ? actual.position.y - Graphics.scale * actual.scale / 10 :
        actual.position.y <= 0 ? actual.position.y + Graphics.scale * actual.scale / 10 : actual.position.y;
    }

    /* Other rects collisions */
    for (int j = i + 1; j < rectColliders.size(); j++) {
      other = rectColliders.get(j);

      ow = (w + other.width()) * 0.5;
      oh = (h + other.height()) * 0.5;
      dx = (actual.position.x + w * 0.5) - (other.position.x + other.width() * 0.5);
      dy = (actual.position.y + h * 0.5) - (other.position.y + other.height() * 0.5);

      /* fill(0x6677CC88);
      rectMode(CENTER);
      rect(dx + width * 0.5, dy + height * 0.5, ow * 2, oh * 2);
      rectMode(CORNER); */

      if (abs(dx) <= ow && abs(dy) <= oh) {
        /* Collision! */
        ow *= dy;
        oh *= dx;

        if (oh > ow) {
          if (oh > -ow) {
            /* Collision on the right */
            other.collisions |= CRIGHT;
            actual.collisions |= CLEFT;
          } else {
            /* at the top */
            other.collisions |= CTOP;
            actual.collisions |= CDOWN;
          }
        } else if (oh > -ow) {
            /* at the bottom */
            other.collisions |= CDOWN;
            actual.collisions |= CTOP;
        } else {
          /* on the left */
          other.collisions |= CLEFT;
          actual.collisions |= CRIGHT;
        }
      }
    }
  }
}
