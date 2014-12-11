//
//  NCFGradientFilter.m
//  FilterGrid
//
//  Created by herui on 16/10/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "NCFGradientFilter.h"

NSString *const kNCFGradientShaderString = SHADER_STRING

(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float specIntensity;
 uniform float specIntensity2;
 
 void main()
 {
     
     vec4 texel = texture2D(inputImageTexture, textureCoordinate);
     vec4 bbTexel = texture2D(inputImageTexture2, textureCoordinate);
     
     vec4 filterResult = mix(texel , bbTexel, specIntensity) *(1.0 + 2.0*specIntensity);
     
     filterResult = vec4(((filterResult.rgb - vec3(0.5)) * specIntensity2 + vec3(0.5)), filterResult.w);
     gl_FragColor = filterResult;
     
 }
 );

@implementation NCFGradientFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kNCFGradientShaderString]))
    {
        return nil;
    }
    
    return self;
}


@end
