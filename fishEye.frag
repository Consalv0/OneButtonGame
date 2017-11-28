#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform float barrelD;

varying vec4 vertColor;
varying vec4 vertTexCoord;

const float PI = 3.1415926535;

vec2 Distort(vec2 p) {
    float theta  = atan(p.y, p.x);
    float radius = length(p);
    radius = pow(radius, barrelD);
    p.x = radius * cos(theta);
    p.y = radius * sin(theta);
    return 0.5 * (p + 1.0);
}

void main() {
  vec2 xy = 2.0 * vertTexCoord.xy - 1.0;

  // float d = length(xy);
  // if (d < 1.0) {
    gl_FragColor = texture(texture, Distort(xy));
  // } else {
  //   uv = vertTexCoord.xy;
  //   gl_FragColor = vec4(0, 0, 0, 0.5);
  // }
}
