

#import "IFHefeFilter.h"

NSString *const kIFHefeShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;  //1
 uniform sampler2D inputImageTexture3;  //2
 uniform sampler2D inputImageTexture4;  //3
 uniform sampler2D inputImageTexture5;  //4
 uniform sampler2D inputImageTexture6;  //5
 uniform float specIntensity;
 uniform float vignetteFlag;
 
 mat3 saturateMatrix = mat3(
                            1.105150,
                            -0.044850,
                            -0.046000,
                            -0.088050,
                            1.061950,
                            -0.089200,
                            -0.017100,
                            -0.017100,
                            1.132900);
 
 vec3 luma = vec3(.3, .59, .11);

 
 void main()
{	
    
         vec4 texel_temp = texture2D(inputImageTexture, textureCoordinate);
         vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
    
         vec2 lookup;
         lookup.y = 0.5;
         lookup.x = texel.r;
         texel.r = texture2D(inputImageTexture2, lookup).r;
         lookup.x = texel.g;
         texel.g = texture2D(inputImageTexture2, lookup).g;
         lookup.x = texel.b;
         texel.b = texture2D(inputImageTexture2, lookup).b;
    
         texel = saturateMatrix * texel;
    
    
         vec2 tc = (2.0 * textureCoordinate) - 1.0;
         float d = dot(tc, tc);
         vec3 sampled;
         lookup.y = 0.5;
         lookup.x = texel.r;
         sampled.r = texture2D(inputImageTexture3, lookup).r;
         lookup.x = texel.g;
         sampled.g = texture2D(inputImageTexture3, lookup).g;
         lookup.x = texel.b;
         sampled.b = texture2D(inputImageTexture3, lookup).b;
         float value = smoothstep(0.0, 1.0, d);
         texel = mix(sampled, texel, value);
    
         lookup.x = texel.r;
         texel.r = texture2D(inputImageTexture4, lookup).r;
         lookup.x = texel.g;
         texel.g = texture2D(inputImageTexture4, lookup).g;
         lookup.x = texel.b;
         texel.b = texture2D(inputImageTexture4, lookup).b;
    
    
         lookup.x = dot(texel, luma);
         texel = mix(texture2D(inputImageTexture5, lookup).rgb, texel, .5);
    
         lookup.x = texel.r;
         texel.r = texture2D(inputImageTexture6, lookup).r;
         lookup.x = texel.g;
         texel.g = texture2D(inputImageTexture6, lookup).g;
         lookup.x = texel.b;
         texel.b = texture2D(inputImageTexture6, lookup).b;
    
         vec4 texel_temp2 = vec4(texel, 1.0);
    
         vec4 filterResult = mix(texel_temp, texel_temp2, specIntensity);
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

@implementation IFHefeFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFHefeShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end
