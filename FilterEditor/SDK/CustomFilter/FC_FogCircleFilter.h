//
//  FC_FogCircleFilter.h
//  FilterCamera
//
//  Created by fuqingping on 14-11-20.
//  Copyright (c) 2014年 Chen.Liu. All rights reserved.
//

#import "FC_FogFilterGroup.h"

@class GPUImageGaussianBlurFilter;

@interface FC_FogCircleFilter : FC_FogFilterGroup{
    GPUImageGaussianBlurFilter *blurFilter;
    GPUImageFilter *fogCircleFilter;
    BOOL hasOverriddenAspectRatio;
}

/** The radius of the circular area being excluded from the blur
 */
@property (readwrite, nonatomic) CGFloat excludeCircleRadius;   //半径，值范围(0.0--1.0)
/** The center of the circular area being excluded from the blur
 */
@property (readwrite, nonatomic) CGPoint excludeCirclePoint;    //圆心点(x,y)(值范围,x:屏幕宽度范围内/屏幕宽度范围内; y:屏幕高度范围内/屏幕高度范围内)
/** The size of the area between the blurred portion and the clear circle
 */
@property (readwrite, nonatomic) CGFloat excludeBlurSize;       //模糊边界宽度（默认给0.2左右）
/** A radius in pixels to use for the blur, with a default of 5.0. This adjusts the sigma variable in the Gaussian distribution function.
 */
@property (readwrite, nonatomic) CGFloat blurRadiusInPixels;    //模糊强度值（最佳为1.0-6.0 ,值太大效率会变的越来越低）
/** The aspect ratio of the image, used to adjust the circularity of the in-focus region. By default, this matches the image aspect ratio, but you can override this value.
 */
@property (readwrite, nonatomic) CGFloat aspectRatio;           //圆类型 1:圆；其他值：椭圆

@end

