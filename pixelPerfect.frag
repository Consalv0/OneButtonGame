#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float time;

uniform sampler2D sprite;
uniform vec2 spriteSize;
uniform sampler2D texture;
uniform vec2 pixelSize;
uniform vec2 pixelOffset;

uniform vec4 baseColor;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  int yi = int(vertTexCoord.x * spriteSize.x);
  int xj = int(vertTexCoord.y * spriteSize.y);
  vec4 spriteValue = texture(sprite, vec2(float(yi) / spriteSize.x, float(xj) / spriteSize.y) + pixelOffset);
  gl_FragColor = baseColor * spriteValue;

  // gl_FragColor *= vec4(vertTexCoord.xy, 0.5+0.5*sin(time), 1.0);
}
