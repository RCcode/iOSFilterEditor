//
//  IFXproIIFilter.m
//  InstaFilters
//
//  Created by Di Wu on 2/28/12.
//  Copyright (c) 2012 twitter:@diwup. All rights reserved.
//

#import "IFXproIIFilter.h"

NSString *const kIFXproIIShaderString = SHADER_STRING
(
precision lowp float;
// 
// varying highp vec2 textureCoordinate;
// 
// uniform sampler2D inputImageTexture;
// uniform sampler2D inputImageTexture2; //map
// uniform sampler2D inputImageTexture3; //vigMap
 
 
 
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 uniform highp float specIntensity;
 uniform float specIntensity2;
 
 void main()
 {
     
//     float temp = specIntensity2;
//     if (temp < 0.001){
//         temp = 0.001;
//     }
     
//     float temp2 = specIntensity;
//     if (temp2 < 0.01){
//         temp2 = 0.01;
//     }
     
     
//     float temp2;
//     
//     float singlePixelSpacing;
//     if (inputImageTexture.width != 0.0)
//     {
//         singlePixelSpacing = 1.0 / inputImageTexture.width;
//     }
//     else
//     {
//         singlePixelSpacing = 1.0 / 2048.0;
//     }
//     
//     if (specIntensity < singlePixelSpacing)
//     {
//         temp2 = singlePixelSpacing;
//     }
//     else
//     {
//         temp2 = specIntensity;
//     }

     
     
     vec2 sampleDivisor = vec2(specIntensity, specIntensity / 1.0);
     
     vec2 samplePos = textureCoordinate - mod(textureCoordinate, sampleDivisor) + 0.5 * sampleDivisor;
     if (specIntensity >= 0.001){
         gl_FragColor = texture2D(inputImageTexture, samplePos);
     }else{
         gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
     }
     
 }
);

@implementation IFXproIIFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFXproIIShaderString]))
    {
		return nil;
    }
    
    return self;
}




@end
