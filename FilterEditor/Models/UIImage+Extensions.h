//
//  UIImage+Extensions.h
//  MirrorDemo
//
//  Created by gaoluyangrc on 14-6-19.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensions)

CGFloat DegreesToRadians(CGFloat degrees);

CGFloat RadiansToDegrees(CGFloat radians);

CGSize workOutSize(float imageWidth,float imageHeight,float orWidth,float orHeight,float widthScole,float heightScole);

CGSize workImageSize(float imageWidth,float imageHeight,float orWidth,float orHeight);

NSDictionary* sourchDictionary();

+ (UIImage *)zoomImage:(UIImage *)image toSize:(CGSize)size;
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;
- ( void )saveToAlbumWithMetadata:(NSDictionary *)metadata
                  customAlbumName:(NSString *)customAlbumName
                  completionBlock:(void(^)(void))completionBlock
                     failureBlock:(void(^)(NSError *error))failureBlock;

- (UIImage *)imageWithBackgroundColor:(UIColor *)bgColor
                           shadeAlpha1:(CGFloat)alpha1
                           shadeAlpha2:(CGFloat)alpha2
                           shadeAlpha3:(CGFloat)alpha3
                           shadowColor:(UIColor *)shadowColor
                          shadowOffset:(CGSize)shadowOffset
                            shadowBlur:(CGFloat)shadowBlur;
- (UIImage *)imageWithShadowColor:(UIColor *)shadowColor
                     shadowOffset:(CGSize)shadowOffset
                       shadowBlur:(CGFloat)shadowBlur;
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

+ (UIImage *)rotate: (UIImage *)image;
- (UIImage *)fixOrientation:(UIImageOrientation)orientation;
- (UIImage *)rotate:(UIImageOrientation)orient;

- (UIImage *)changeTintColor:(UIColor *)tintColor;

- (UIImage *)changeGraph:(UIImage *)image;

- (UIImage *)subImageWithRect:(CGRect)rect;

+ (UIImage *)shapeMakeWithBottomImage:(UIImage *)_bottomImage imageBold:(UIImage *)_boldImage andTopImage:(UIImage *)_topImage andBlendMode:(CGBlendMode)blendMode;

+ (UIImage *)getImageFromView:(UIView *)view;

+ (UIImage *)getEditFinishedImageWithView:(UIView *)backView andContextSize:(CGSize)size;

- (UIImage *)rescaleImageToSize:(CGSize)size;

- (UIImage *)turnShapeWithImage:(UIImage *)image;

@end
