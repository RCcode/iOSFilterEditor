//
//  FC_LightingFilter.m
//  FilterCamera
//
//  Created by MAXToooNG on 14-9-12.
//  Copyright (c) 2014年 Chen.Liu. All rights reserved.
//

#import "FC_LightingFilter.h"
NSString *const kFCLightingShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float specIntensity;
 uniform float vignetteFlag;
 
 void main()
 {
     
     vec4 texel = texture2D(inputImageTexture, textureCoordinate);
     vec4 bbTexel = texture2D(inputImageTexture2, textureCoordinate);
     
     vec4 filterResult;
     float temp = specIntensity;
     if (temp > .6){
         temp = .6;
     }
     filterResult = mix(texel , bbTexel, temp) *(1.0 + temp*1.9);
     
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
@implementation FC_LightingFilter
- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kFCLightingShaderString]))
    {
		return nil;
    }
    return self;
}
@end
