#import "IFLordKelvinFilter.h"

NSString *const kLordKelvinShaderString = SHADER_STRING
(
 precision lowp float;
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform float specIntensity;
 uniform float vignetteFlag;
 
 void main()
 {
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     vec3 texel2;
     vec2 lookup;
     
     lookup.y = .5;
     lookup.x = texel.r;
     texel2.r = texture2D(inputImageTexture2, lookup).r;
     lookup.x = texel.g;
     texel2.g = texture2D(inputImageTexture2, lookup).g;
     lookup.x = texel.b;
     texel2.b = texture2D(inputImageTexture2, lookup).b;
     
     vec4 filterResult = vec4(mix(texel, texel2, specIntensity), 1.0);
     if (vignetteFlag > .0){
        vec3 lumaCoeffs = vec3(.3, .59, .11);
        vec2 vignetteCenter = vec2( .5, .5);
        vec3 vignetteColor = vec3(.0, .0, .0);
        float vignetteStart = .3;
        float vignetteEnd = .70;
        float d = distance(textureCoordinate, vec2(vignetteCenter.x, vignetteCenter.y));
        float percent = smoothstep(vignetteStart, vignetteEnd, d);
        filterResult = vec4(mix(filterResult.rgb, vignetteColor, percent), filterResult.a);
     }
     gl_FragColor = filterResult;
 }
);

@implementation IFLordKelvinFilter
 int timeUniformLocation;


- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kLordKelvinShaderString]))
    {
		return nil;
    }
    
    return self;
}

- (void)setStrength:(CGFloat)newValue;
{

    [self setFloat:newValue forUniformName:@"strength"];
}


@end
