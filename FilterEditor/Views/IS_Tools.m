//
//  IS_Tools.m
//  iOSNoCropVideo
//
//  Created by TCH on 14-8-27.
//  Copyright (c) 2014年 com.rcplatformhk. All rights reserved.
//

#import "IS_Tools.h"

@implementation IS_Tools

+ (void)ViewAnimation:(UIView*)view withFrame:(CGRect)frame
{
    __weak UIView *v = view;
    [UIView animateWithDuration:0.3 animations:^{
        v.frame = frame;
    } completion:nil];
}

+ (void)viewFadeAnimation:(UIView *)view fadeIn:(BOOL)fadeIn
{
    if (fadeIn) {
        view.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            view.alpha = 1;
        }];
    }
    else
    {
        view.alpha = 1;
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 0;
        }];
    }
}

+ (UIImage *)getViewImage:(UIView *)view
{
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIViewController*)viewController:(UIView *)view
{
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
