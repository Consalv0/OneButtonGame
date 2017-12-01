/* Collision Flags */
final int CTOP = 2;
final int CDOWN = 4;
final int CLEFT = 8;
final int CRIGHT = 16;
final int CHORIZONTAL = CTOP | CDOWN;
final int CVERTICAL = CLEFT | CRIGHT;

ArrayList<GameObject> rectColliders = new ArrayList<GameObject>();

void checkCollisions() {
  for (int i = 0; i < rectColliders.size(); i++) { rectColliders.get(i).collisions = 0; }

  float w, h, ow, oh;
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
      actual.position.x = actual.position.x + w >= width ? actual.position.x - Graphics.scale * actual.scale :
        actual.position.x <= 0 ? actual.position.x + Graphics.scale * actual.scale : actual.position.x;
      actual.position.y = actual.position.y + h >= height ? actual.position.y - Graphics.scale * actual.scale :
        actual.position.y <= 0 ? actual.position.y + Graphics.scale * actual.scale : actual.position.y;
    }

    /* Other rects colliders collisions */
    for (int j = i + 1; j < rectColliders.size(); j++) {
      other = rectColliders.get(j);
      ow = other.width();
      oh = other.height();

      if (actual.position.x < other.position.x + ow && actual.position.x > other.position.x - ow / 2) {
        if (!(actual.position.y > other.position.y + oh || actual.position.y + h < other.position.y)) {
          other.collisions |= CRIGHT;
          actual.collisions |= CLEFT;
          actual.onCollision(other); other.onCollision(actual);
        }
      }
      if (actual.position.x + w > other.position.x && actual.position.x + w < other.position.x + ow / 2) {
        if (!(actual.position.y > other.position.y + oh || actual.position.y + h < other.position.y)) {
          other.collisions |= CLEFT;
          actual.collisions |= CRIGHT;
          actual.onCollision(other); other.onCollision(actual);
        }
      }
      if (actual.position.y < other.position.y + oh && actual.position.y > other.position.y - oh / 2) {
        if (!(actual.position.x > other.position.x + ow || actual.position.x + w < other.position.x)) {
          other.collisions |= CTOP;
          actual.collisions |= CDOWN;
          actual.onCollision(other); other.onCollision(actual);
        }
      }
      if (actual.position.y + h > other.position.y && actual.position.y + h < other.position.y + oh / 2) {
        if (!(actual.position.x > other.position.x + ow || actual.position.x + w < other.position.x)) {
          other.collisions |= CTOP;
          actual.collisions |= CDOWN;
          actual.onCollision(other); other.onCollision(actual);
        }
      }
    }
  }
}
