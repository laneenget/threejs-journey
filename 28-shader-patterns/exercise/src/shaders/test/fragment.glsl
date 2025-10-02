#define PI 3.14159

varying vec2 vUv;

float random(vec2 st)
{
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

vec2 rotate(vec2 uv, float rotation, vec2 mid)
{
    return vec2
    (
        cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x,
        cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.y
    );
}

vec2 fade(vec2 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}

vec4 permute(vec4 x)
{
    return mod(((x*34.0)+1.0)*x, 289.0);
}

float cnoise(vec2 P){
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;
  vec4 i = permute(permute(ix) + iy);
  vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
  vec4 gy = abs(gx) - 0.5;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;
  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);
  vec4 norm = 1.79284291400159 - 0.85373472095314 * 
    vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
  g00 *= norm.x;
  g01 *= norm.y;
  g10 *= norm.z;
  g11 *= norm.w;
  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));
  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

void main()
{
    // Pattern 3
    float strengthX = vUv.x;

    // Pattern 4
    float strengthY = vUv.y;

    // Pattern 5
    float negStrengthY = 1.0 - vUv.y;

    // Pattern 6
    float fastStrengthY = vUv.y * 10.0;

    // Pattern 7
    float repeatStrengthY = mod(vUv.y * 10.0, 1.0);

    // Pattern 8
    float barsStrengthY = mod(vUv.y * 10.0, 1.0);
    barsStrengthY = step(0.5, barsStrengthY);

    // Pattern 9
    float thinBarsStrengthY = mod(vUv.y * 10.0, 1.0);
    thinBarsStrengthY = step(0.8, thinBarsStrengthY);

    // Pattern 10
    float thinBarsStrengthX = mod(vUv.x * 10.0, 1.0);
    thinBarsStrengthX = step(0.8, thinBarsStrengthX);

    // Pattern 11
    float crossHatchBarsStrength = step(0.8, mod(vUv.x * 10.0, 1.0));
    crossHatchBarsStrength += step(0.8, mod(vUv.y * 10.0, 1.0));

    // Pattern 12
    float polkaDotStrength = step(0.8, mod(vUv.x * 10.0, 1.0));
    polkaDotStrength *= step(0.8, mod(vUv.y * 10.0, 1.0));

    // Pattern 13
    float dashStrength = step(0.8, mod(vUv.y * 10.0, 1.0));
    dashStrength -= step(0.8, mod(vUv.x * 10.0, 1.0));

    // Pattern 14
    float cornerX = step(0.4, mod(vUv.x * 10.0, 1.0));
    cornerX *= step(0.8, mod(vUv.y * 10.0, 1.0));

    float cornerY = step(0.8, mod(vUv.x * 10.0, 1.0));
    cornerY *= step(0.4, mod(vUv.y * 10.0, 1.0));

    float cornerStrength = cornerX + cornerY;

    // Pattern 15
    float plusX = step(0.4, mod(vUv.x * 10.0, 1.0));
    plusX *= step(0.8, mod(vUv.y * 10.0 + 0.2, 1.0));

    float plusY = step(0.8, mod(vUv.x * 10.0 + 0.2, 1.0));
    plusY *= step(0.4, mod(vUv.y * 10.0, 1.0));

    float plusStrength = plusX + plusY;

    // Pattern 16
    float middleGradientStrength = abs(vUv.x - 0.5);

    // Pattern 17
    float minGradientStrength = min(abs(vUv.x - 0.5), abs(vUv.y - 0.5)); 

    // Pattern 18
    float maxGradientStrength = max(abs(vUv.x - 0.5), abs(vUv.y - 0.5));

    // Pattern 19
    float thickBoxStrength = step(0.2, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));

    // Pattern 20
    float thinBox1 = step(0.2, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));
    float thinBox2 = 1.0 - step(0.25, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));
    float thinBoxStrength = thinBox1 * thinBox2;

    // Pattern 21
    float stepGradientStrength = floor(vUv.x * 10.0) / 10.0;

    // Pattern 22
    float boxGradientStrength = floor(vUv.x * 10.0) / 10.0;
    boxGradientStrength *= floor(vUv.y * 10.0) / 10.0;

    // Pattern 23
    float staticStrength = random(vUv);

    // Pattern 24
    vec2 gridUV = vec2(
        floor(vUv.x * 10.0) / 10.0,
        floor(vUv.y * 10.0) / 10.0
    );
    float randomBoxStrength = random(gridUV);

    // Pattern 25
    vec2 slantGridUV = vec2(
        floor(vUv.x * 10.0) / 10.0,
        floor((vUv.y + vUv.x * 0.5) * 10.0) / 10.0
    );
    float slantRandomBoxStrength = random(slantGridUV);

    // Pattern 26
    float cornerGradientStrength = length(vUv);

    // Pattern 27
    float centerGradientStrength = distance(vUv, vec2(0.5));

    // Pattern 28
    float whiteCenterStrength = 1.0 - distance(vUv, vec2(0.5));

    // Pattern 29
    float whiteDotStrength = 0.015 / distance(vUv, vec2(0.5));

    // Pattern 30
    vec2 lightUV = vec2(
        vUv.x * 0.1 + 0.45,
        vUv.y * 0.5 + 0.25
    );
    float whiteDotStretchStrength = 0.015 / distance(lightUV, vec2(0.5));

    // Pattern 31
    vec2 whiteStarUVX = vec2(
        vUv.x * 0.1 + 0.45,
        vUv.y * 0.5 + 0.25
    );
    float whiteStarX = 0.015 / distance(whiteStarUVX, vec2(0.5));

    vec2 whiteStarUVY = vec2(
        vUv.y * 0.1 + 0.45,
        vUv.x * 0.5 + 0.25
    );
    float whiteStarY = 0.015 / distance(whiteStarUVY, vec2(0.5));

    float whiteStarStrength = whiteStarX * whiteStarY;

    // Pattern 32
    vec2 rotatedUV = rotate(vUv, PI * 0.25, vec2(0.5));

    vec2 whiteStarRotatedUVX = vec2(
        rotatedUV.x * 0.1 + 0.45,
        rotatedUV.y * 0.5 + 0.25
    );
    float whiteStarRotatedX = 0.015 / distance(whiteStarRotatedUVX, vec2(0.5));

    vec2 whiteStarRotatedUVY = vec2(
        rotatedUV.y * 0.1 + 0.45,
        rotatedUV.x * 0.5 + 0.25
    );
    float whiteStarRotatedY = 0.015 / distance(whiteStarRotatedUVY, vec2(0.5));

    float whiteStarRotatedStrength = whiteStarRotatedX * whiteStarRotatedY;

    // Pattern 33
    float blackDotStrength = step(0.25, distance(vUv, vec2(0.5)));

    // Pattern 34
    float blackDotGradientStrength = abs(distance(vUv, vec2(0.5)) - 0.25);

    // Pattern 35
    float blackCircleStrength = step(0.01, abs(distance(vUv, vec2(0.5)) - 0.25));

    // Pattern 36
    float whiteCircleStrength = 1.0 - step(0.01, abs(distance(vUv, vec2(0.5)) - 0.25));

    // Pattern 37
    vec2 whiteCircleSinUV = vec2(
        vUv.x,
        vUv.y + sin(vUv.x * 30.0) * 0.1
    );
    float whiteCircleSinStrength = 1.0 - step(0.01, abs(distance(whiteCircleSinUV, vec2(0.5)) - 0.25));

    // Pattern 38
    vec2 whiteCircleSinUVXY = vec2(
        vUv.x + sin(vUv.y * 30.0) * 0.1,
        vUv.y + sin(vUv.x * 30.0) * 0.1
    );
    float whiteCircleSinXYStrength = 1.0 - step(0.01, abs(distance(whiteCircleSinUVXY, vec2(0.5)) - 0.25));

    // Pattern 39
    vec2 whiteWaffleUV = vec2(
        vUv.x + sin(vUv.y * 100.0) * 0.1,
        vUv.y + sin(vUv.x * 100.0) * 0.1
    );
    float whiteWaffleStrength = 1.0 - step(0.01, abs(distance(whiteWaffleUV, vec2(0.5)) - 0.25));

    // Pattern 40
    float angle = atan(vUv.x, vUv.y);
    float angleStrength = angle;

    // Pattern 41
    float angleOffset = atan(vUv.x - 0.5, vUv.y - 0.5);
    float angleOffsetStrength = angleOffset;

    // Pattern 42
    float angleOffsetFullCircle = atan(vUv.x - 0.5, vUv.y - 0.5);
    angleOffsetFullCircle /= PI * 2.0;
    angleOffsetFullCircle += 0.5;
    float angleOffsetFullCircleStrength = angleOffsetFullCircle;

    // Pattern 43
    float angleSpiral = atan(vUv.x - 0.5, vUv.y - 0.5);
    angleSpiral /= PI * 2.0;
    angleSpiral += 0.5;
    angleSpiral *= 20.0;
    angleSpiral = mod(angleSpiral, 1.0);
    float angleSpiralStrength = angleSpiral;

    // Pattern 44
    float angleOppositeSpiral = atan(vUv.x - 0.5, vUv.y - 0.5);
    angleOppositeSpiral /= PI * 2.0;
    angleOppositeSpiral += 0.5;
    float angleOppositeSpiralStrength = sin(angleOppositeSpiral * 100.0);
    
    // Pattern 45
    float flowerAngle = atan(vUv.x - 0.5, vUv.y - 0.5);
    flowerAngle /= PI * 2.0;
    flowerAngle += 0.5;
    float sinusoid = sin(flowerAngle * 100.0);
    float radius = 0.25 + sinusoid * 0.02;
    float flowerStrength = 1.0 - step(0.01, abs(distance(vUv, vec2(0.5)) - radius));

    // Pattern 46 -- used to create smoke, clouds, terrain elevation, etc.
    float perlinNoiseStrength = cnoise(vUv * 10.0);

    // Pattern 47
    float cowhideStrength = step(0.0, cnoise(vUv * 10.0));

    // Pattern 48
    float glowingLinesStrength = 1.0 - abs(cnoise(vUv * 10.0));

    // Pattern 49
    float oilSpillStrength = sin(cnoise(vUv * 10.0) * 20.0);

    // Pattern 50
    float sharpOilSpillStrength = step(0.9, sin(cnoise(vUv * 10.0) * 20.0));

    // Clamp the strength
    strength = clamp(strength, 0.0, 1.0);
    
    // Color version
    vec3 blackColor = vec3(0.0);
    vec3 uvColor = vec3(vUv, 1.0);
    vec3 mixedColor = mix(blackColor, uvColor, sharpOilSpillStrength);

    gl_FragColor = vec4(mixedColor, 1.0);
}