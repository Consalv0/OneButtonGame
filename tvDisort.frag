#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform float barrelD;
uniform float aberration;

varying vec4 vertColor;
varying vec4 vertTexCoord;

const int NUMITER = 9;
const float RECINUMITERF = 1.0 / float(NUMITER);
const float PI = 3.1415926535;

// vec2 barrelDistort(vec2 coord, float amt) {
// 	vec2 cc = coord - 0.5;
// 	float dist = dot(cc, cc);
// 	return coord + cc * dist * amt;
// }
vec2 barrelDistort(vec2 coord, float amt) {
	float dist = dot(coord, coord);
	return coord + coord * dist * amt;
}

float sat(float t) {
	return clamp(t, 0.0, 1.0);
}

float linterp(float t) {
	return sat( 1.0 - abs( 2.0*t - 1.0 ) );
}

float remap(float t, float a, float b) {
	return sat((t - a) / (b - a));
}

vec4 spectrum_offset(float t) {
	vec4 ret;
	float lo = step(t,0.5);
	float hi = 1.0-lo;
	float w = linterp( remap( t, 1.0/6.0, 5.0/6.0 ) );
	ret = vec4(lo,1.0,hi, 1.) * vec4(1.0-w, w, 1.0-w, 1.);

	return pow( ret, vec4(1.0/2.2) );
}

vec2 distort(vec2 p) {
  float theta  = atan(p.y, p.x);
  float radius = sqrt(pow(p.x, 2.0) + pow(p.y, 2.0));
  radius = pow(radius, barrelD);
  p.x = radius * cos(theta);
  p.y = radius * sin(theta);
  return 0.5 * (p + 1.0);
}

void main() {

  vec2 xy = 0.8 * vertTexCoord.xy - 0.4;

  vec4 sumcol = vec4(0.0);
  vec4 sumw = vec4(0.0);
	vec2 bD = distort(xy);

  for (int i = 0; i < NUMITER; ++i) {
  	float t = float(i) * RECINUMITERF;
  	vec4 w = spectrum_offset( t );
  	sumw += w;
  	sumcol += w * texture(texture, barrelDistort(xy, aberration * t) + bD);
  }

  gl_FragColor = sumcol / sumw;

  // float d = length(xy);
  // if (d < barrelD - 0.1) {
    // gl_FragColor = texture(texture, distort(xy));
  // } else {
  //   gl_FragColor = texture(texture, vertTexCoord.xy) - vec4(0.3);
  // }
}
