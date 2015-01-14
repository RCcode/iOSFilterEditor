//
//  IS_Tools.h
//  iOSNoCropVideo
//
//  Created by TCH on 14-8-27.
//  Copyright (c) 2014年 com.rcplatformhk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IS_Tools : NSObject

+ (void)ViewAnimation:(UIView*)view withFrame:(CGRect)frame;
+ (void)viewFadeAnimation:(UIView *)view fadeIn:(BOOL)fadeIn;
+ (UIViewController*)viewController:(UIView *)view;

@end
