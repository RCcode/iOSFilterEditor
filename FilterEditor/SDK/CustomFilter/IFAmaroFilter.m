
#import "IFAmaroFilter.h"

NSString *const kIFAmaroShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 varying lowp vec4 vColor;
 
 uniform sampler2D inputImageTexture;
// uniform sampler2D inputImageTexture2; //blowout;
// uniform sampler2D inputImageTexture3; //overlay;
// uniform sampler2D inputImageTexture4; //map
 uniform float specIntensity;
 uniform float vignetteFlag;
 
 void main()
 {
     
     //怀旧
     mat4 colorMatrix = mat4(0.3588, 0.7044, 0.1368, 0.0,
                             0.2990, 0.5870, 0.1140, 0.0,
                             0.2392, 0.4696, 0.0912 ,0.0,
                             0,0,0,1.0);
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 outputColor = textureColor * colorMatrix;
     
     vec4 filterResult;
     filterResult = (specIntensity * outputColor) + ((1.0 - specIntensity) * textureColor);
     
     
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

@implementation IFAmaroFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFAmaroShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end
