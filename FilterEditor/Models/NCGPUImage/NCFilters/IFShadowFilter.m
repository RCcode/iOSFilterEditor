#import "IFShadowFilter.h"

NSString *const kShadowShaderString = SHADER_STRING
(
 precision lowp float;
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 uniform float specIntensity;
 uniform float specIntensity3;
 uniform float vignetteFlag;
 
 void main()
 {
     
     vec4 texel = texture2D(inputImageTexture, textureCoordinate);
     
     vec4 meng1 = texture2D(inputImageTexture2, textureCoordinate);
     
     vec4 filterResult1 = mix(texel , meng1, specIntensity) * (1.0 + 1.5 * specIntensity);
     
     vec4 meng2 = texture2D(inputImageTexture3, textureCoordinate);
     
     vec4 filterResult = mix(filterResult1, meng2, specIntensity3 * (1.0/(specIntensity + 0.01)) * specIntensity) * (1.0 + 1.5 * specIntensity3* (1.0/(specIntensity + 0.01)) * specIntensity);

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

@implementation IFShadowFilter
 int timeUniformLocation;

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kShadowShaderString]))
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
