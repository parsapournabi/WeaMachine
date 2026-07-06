#version 130

/** Definitions **/
#define PI 3.1415926535897932384626
#define PI2 (PI * 2.)
#define PI_2 (PI * .5)
#define PI_4 (PI * .25)

/** Structures **/
struct SplashAnim
{
    float blur;
    float glitch;
    float rgb;
    float glow;
    float lightning;
    float spark;
    float sweep;
    float opacity;
    float breathe;
    float burst;
};

/** Uniforms **/
uniform sampler2D u_source;
uniform vec4 u_baseColor;
uniform vec2 u_resolution;
uniform vec2 u_logoSize;
uniform float u_minimumDuration;
uniform float u_time;
uniform float qt_Opacity;

/** Vertex/Fragment In/Out **/
varying highp vec2 qt_TexCoord0;

/** Functions **/

// Utilities
float hash(vec2 p)
{
    return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);
}

float hash(float p) {
    return hash(vec2(p));
}

float noise(vec2 p)
{
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i+vec2(1,0));
    float c = hash(i+vec2(0,1));
    float d = hash(i+vec2(1,1));

    vec2 u = f*f*(3.0-2.0*f);

    return mix(a,b,u.x)+
            (c-a)*u.y*(1.0-u.x)+
            (d-b)*u.x*u.y;
}

float noise(float p) {
    return noise(vec2(p));
}

// Splash Helper functions
float spark(vec2 uv)
{
    float t = u_time * 6.0;

    vec2 p = uv;
    p *= 40.0;
    p += vec2(t,-t*0.7);

    float n = noise(p);
    n = smoothstep(.985,.999,n);

    return n;
}

SplashAnim anim(float time)
{
    SplashAnim a;

    float duration = u_minimumDuration;
    float t = clamp(time / duration, 0.0, 1.0);

    // Blur
    a.blur = 8.0 * (1.0 - smoothstep(0.00,0.38,t)) + 4.0 * smoothstep(0.7,1.00,t);

    // Glitch
    a.glitch = smoothstep(0.6,0.8,t) * (1.0 - smoothstep(1.,1.,t));

    // RGB Split
    a.rgb = smoothstep(0.57,0.88,t) * (1.0 - smoothstep(0.7,0.99,t));

    // Glow
    a.glow = smoothstep(0.02,0.10,t) * (1.0 - smoothstep(0.65,0.80,t));

    // Lightning
    a.lightning = smoothstep(0.7,0.85,t) * (1.0 - smoothstep(1.,1.,t));

    // Spark
    a.spark = 0.15 + 0.85*sin(t*PI);

    // Sweep
    a.sweep = smoothstep(0.75,0.90,t);

    // Fade Out
    a.opacity = 1.0 - smoothstep(0.96,1.00,t);

    // Breathing
    a.breathe = 1.0 + 0.01*sin(time*0.8);

    // Final Burst (Boosting up the noises)
    a.burst = smoothstep(0.65,0.79,t) * (1.0-smoothstep(0.99,0.99,t));

    return a;
}

void main(void)
{
    // Forwarding uniforms & varyings
    vec4 baseColor = u_baseColor;
    vec2 screenUV = qt_TexCoord0;
    vec2 resolution = u_resolution;
    vec2 logoSize = u_logoSize;
    float time = u_time;

    vec2 frag = screenUV * resolution; // FragCoord

    vec2 logoMin = (resolution - logoSize) * 0.5;
    vec2 logoMax = logoMin + logoSize;

    vec2 logoUV = (frag - logoMin) / logoSize;
    vec2 sampleUV = logoUV;

    logoUV.y += .5;

    SplashAnim A = anim(time);

    // Applying small logo breath scaling
    logoUV = (logoUV - .5) / A.breathe + .5;

    float side = smoothstep(0., 1., logoUV.x);
    float n = noise(logoUV*25.0 + time);

    float band = floor(logoUV.y * 80.0);
    float bandRnd = hash(vec2(band, floor(time * 40.0)));
    float glitch = hash(vec2(band, floor(time * 18.0)))-0.5;

    glitch *= step(.01,bandRnd);
    glitch *= A.glitch;
    glitch *= 1.0+A.burst*2.0; // At the end glitch should be boost
    glitch *= 0.5 + 0.5 * noise(vec2(time * 18.0, 2.3));

    // Applying glitch to the X axis
    logoUV.x += glitch * bandRnd * noise(time *.5);

    // Applying Wave to the Y axis half right-side
    logoUV.y += side * sin(logoUV.x * 30.0 + time * 5.0) * 0.01;

    // RGB Helper
    vec2 ca = vec2(.003 * A.rgb, 0.0); // Increase baseValue to have RGB mixing while glitching
    vec4 r = texture2D(u_source, logoUV + ca);
    vec4 g = texture2D(u_source, logoUV);
    vec4 b = texture2D(u_source, logoUV - ca);
    vec4 c = vec4(r.r, g.g, b.b, g.a);

    // Blur Calculation
    vec4 blur = vec4(0.0);
    for(int x = -2; x<= 2; x++) {
        for(int y = -2; y<= 2; y++)
        {
            blur += texture2D(u_source,
                              logoUV + vec2(x,y) / resolution * A.blur * 10.);
        }
    }
    blur /= 25.0;

    // Applying Blur & RGB Helper
    vec4 color = max(c,blur * 1.6);
    color.rgb *= mix(vec3(1.), baseColor.rgb, side);

    // Glowing with Anti-Aliasing
    float edge = max(abs(dFdx(c.a)), abs(dFdy(c.a)));
    color.rgb += edge * (2.0 + 4.0 * A.glow);

    // Optional bolt noise
    // float bolt = 0.0;
    // for(int i = 0; i < 12; i++)
    // {
    //     vec2 p = logoUV;
    //     p*= 7.0;
    //     p+= vec2(float(i) * 3.0, time * 10.0);

    //     float n = noise(p);
    //     bolt = max(bolt, smoothstep(.985, 1.0, n));
    // }
    // // Applying Bolt noise
    // color.rgb += bolt * A.lightning * baseColor;

    // Sparking noises at the space
    color.rgb += spark(sampleUV * .5) * A.spark * baseColor.rgb;

    color.rgb *= A.opacity;
     // Clamping Reflects
    color = clamp(color * qt_Opacity, .02, 1.);
    gl_FragColor = color;
}
