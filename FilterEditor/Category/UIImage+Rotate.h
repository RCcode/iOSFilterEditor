//
//  UIImage+Rotate.h
//  BeautySelfie
//
//  Created by MAXToooNG on 14-5-23.
//  Copyright (c) 2014年 Chen.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    kOrientationUp,
    kOrientationRight,
    kOrientationDown,
    kOrientationLeft,
    
    kOrientationUnKown,
} Orientation;

typedef enum{
    kRotateImageCropModeClip,
    kRotateImageCropModeExpand,
}RotateImageCropMode;

@interface UIImage (Rotate)
+ (UIImage *)rotate: (UIImage *)image;
- (UIImage *)fixOrientation:(UIImageOrientation)orientation;

/**
 *  获取指定朝向的图片
 *
 *  @param orientation 指定的方向
 */
- (UIImage *)rotateImageWithOrientation:(Orientation)orientation;

/**
 *  获取水平镜像图片
 */
- (UIImage *)imageForMirrorVertically;

/**
 *  获取垂直镜像图片
 */
- (UIImage *)imageForMirrorHorizontally;

- (UIImage*)rotateImageWithRadian:(CGFloat)radian cropMode:(RotateImageCropMode)cropMode;

@end
