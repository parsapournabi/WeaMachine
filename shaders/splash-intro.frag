#version 130

#define EPS 1e-06
#define PI 3.1415926535897932384626
#define PI2 (PI * 2.)
#define PI_2 (PI * .5)
#define PI_4 (PI * .25)

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

uniform sampler2D source;
uniform vec4 uBaseColor;
uniform vec2 uResolution;
uniform float u_minimumDuration;
uniform float iTime;

uniform float qt_Opacity;
varying highp vec2 qt_TexCoord0;

float hash(vec2 p)
{
    return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);
}

float hash(float p) {
    return hash(vec2(p));
}

float noise(vec2 p)
{
    vec2 i=floor(p);
    vec2 f=fract(p);

    float a=hash(i);
    float b=hash(i+vec2(1,0));
    float c=hash(i+vec2(0,1));
    float d=hash(i+vec2(1,1));

    vec2 u=f*f*(3.0-2.0*f);

    return mix(a,b,u.x)+
            (c-a)*u.y*(1.0-u.x)+
            (d-b)*u.x*u.y;
}

float noise(float p) {
    return noise(vec2(p));
}

float spark(vec2 uv)
{
    float t=iTime*6.0;

    vec2 p=uv;

    p*=40.0;

    p+=vec2(t,-t*0.7);

    float n=noise(p);

    n=smoothstep(.985,.999,n);

    return n;
}


SplashAnim anim(float time)
{
    SplashAnim a;

    float duration = u_minimumDuration;

    float t = clamp(time / duration, 0.0, 1.0);

    //-------------------------
    // Blur
    //-------------------------

    a.blur =
        8.0 * (1.0 - smoothstep(0.00,0.38,t))
      + 4.0 * smoothstep(0.7,1.00,t);

    //-------------------------
    // Glitch
    //-------------------------

    a.glitch =
        smoothstep(0.6,0.8,t)
      * (1.0 - smoothstep(1.,1.,t));

    //-------------------------
    // RGB Split
    //-------------------------

    a.rgb =
        smoothstep(0.57,0.88,t)
      * (1.0 - smoothstep(0.7,0.99,t));

    //-------------------------
    // Glow
    //-------------------------

    a.glow =
        smoothstep(0.02,0.10,t)
      * (1.0 - smoothstep(0.65,0.80,t));

    //-------------------------
    // Lightning
    //-------------------------

    a.lightning =
        smoothstep(0.7,0.85,t)
      * (1.0 - smoothstep(1.,1.,t));

    //-------------------------
    // Spark
    //-------------------------

    a.spark =
        0.15 + 0.85*sin(t*PI);

    //-------------------------
    // Sweep
    //-------------------------

    a.sweep =
        smoothstep(0.75,0.90,t);

    //-------------------------
    // Fade Out
    //-------------------------

    a.opacity =
        1.0 - smoothstep(0.96,1.00,t);

    //-------------------------
    // Breathing
    //-------------------------

    a.breathe =
        1.0 + 0.01*sin(time*0.8);

    //-------------------------
    // Final Burst
    //-------------------------

    a.burst =
        smoothstep(0.65,0.79,t)
      * (1.0-smoothstep(0.99,0.99,t));

    return a;
}

void main(void)
{
    vec2 screenUV = qt_TexCoord0;
    vec2 resolution = uResolution;
    vec2 logoSize = vec2(200.0, 200.0);
    vec2 frag = screenUV * resolution;

    vec2 logoMin = (resolution - logoSize) * 0.5;
    vec2 logoMax = logoMin + logoSize;

    vec2 logoUV = (frag - logoMin) / logoSize;
    vec2 sampleUV = logoUV;
    logoUV.y += .5;

    SplashAnim A = anim(iTime);

    logoUV=(logoUV-.5)/A.breathe+.5;

    // sampler2D source = iChannel2;

    // bool valid = true;
    // if(any(lessThan(uv, vec2(0.0))) ||
    //    any(greaterThan(uv, vec2(1.0))))
    // {
    //     gl_FragColor = vec4(0.0);
    //     // source = sampler2D();
    //     // valid = false;
    //     return;
    // }

    // vec2 uv = qt_TexCoord0;
    float time = iTime;

    float rnd=floor(iTime*18.0);

    // float side = step(0.49, logoUV.x);
    float side = smoothstep(0., 1., logoUV.x);
    float n = noise(logoUV*25.0 + time);


    float band=floor(logoUV.y*80.0);
    float bandRnd = hash(vec2(band,floor(iTime*40.0)));
    float ggg = hash(vec2(band,rnd))-0.5;

    ggg*=step(.01,bandRnd);

    ggg*=A.glitch;
    ggg*=1.0+A.burst*2.0;
    // ggg*=0.3+ 0.7*noise(vec2(bandRnd,time*15.0));
    ggg *=
    0.5 +
    0.5 *
    noise(vec2(time * 18.0, 2.3));

    logoUV.x+=ggg * bandRnd * noise(time *.5);

    // uv.x += side * (n-0.5)*0.03;
    logoUV.y += side * sin(logoUV.x*30.0+time*5.0)*0.01;

    vec2 ca=vec2(.003 * A.rgb,0);
    vec4 r= texture2D(source,logoUV+ca);
    vec4 g= texture2D(source,logoUV);
    vec4 b= texture2D(source,logoUV-ca);
    vec4 c;
    c.r=r.r;
    c.g=g.g;
    c.b=b.b;
    c.a=g.a;

    // c = texture2D(source,uv);
    // c = texture2D(source,logoUV);

    vec4 blur=vec4(0.0);

    for(int x=-2;x<=2;x++)
        for(int y=-2;y<=2;y++)
        {
            blur+=texture2D(
                        source,
                        logoUV+
                        vec2(x,y)/resolution* A.blur * 10.
                        );
        }

    blur/=25.0;

    vec4 color = max(c,blur*1.6);
    // color.rgb *= vec3(0.75,0.92,1.0);
    color.rgb *= mix(vec3(1.), uBaseColor.rgb, side);
    // color.rgb *= vec3(.7, .1, .3);

    float edge=max(
                abs(dFdx(c.a)),
                abs(dFdy(c.a)));
    color.rgb+=edge*(2.0+4.0*A.glow);

    float bolt=0.0;

    for(int i=0;i<12;i++)
    {
        vec2 p=logoUV;

        p*=7.0;

        p+=vec2(float(i)*3.0,iTime*10.0);

        float n=noise(p);

        bolt=max(bolt, smoothstep(.985,1.0,n));
    }

    // color.rgb+=bolt* vec3(.6,.85,1.2);
    // color.rgb += bolt * A.lightning * vec3(.65,.85,1.2);
    // color.rgb += bolt * A.lightning;

    // float scan = smoothstep( 0.98, 1.0, sin(screenUV.y*250.0+time*8.0) );
    // color += scan*0.15;
    // color.rgb += scan*0.05*vec3(0.8,0.95,1.2);

    // color.rgb += spark(logoUV*.5) * A.spark;//*vec3(0.8,0.95,1.2);
    color.rgb += spark(sampleUV*.5) * A.spark * uBaseColor.rgb;//*vec3(0.8,0.95,1.2);


    float pulse = 0.5+ 0.5*sin(time*2.0);
    // color*=1.0+0.2*pulse;


    float p = step( 0.995, noise(vec2(sampleUV.y*50.0, time*2.0 )) );
    // color.rgb += p*vec3(0.8,0.95,1.2);


    float line = smoothstep( 0.499, 0.500, logoUV.x) - smoothstep( 0.500, 0.501, logoUV.x);
    // color += vec4(line);

    // float sweepPos = mix(-0.4,1.4,A.sweep);
    // float sweep = smoothstep(0.00,0.02, logoUV.x+logoUV.y-sweepPos) - smoothstep(0.02, 0.05, logoUV.x+logoUV.y-sweepPos);
    // color.rgb += sweep;

    vec4 background0 = vec4(.0156, 0.0234, .03125, 1.);
    vec4 background1 = vec4(.062, .078, .105, 1.);
    vec4 backgroundColor = mix(background0, background1, screenUV.y);
    backgroundColor = clamp(backgroundColor, .01, 1.);


    color.rgb *= A.opacity;
    color = clamp(color * qt_Opacity, .02, 1.);
    // color = mix(backgroundColor, color, color);
    gl_FragColor = color;
}
