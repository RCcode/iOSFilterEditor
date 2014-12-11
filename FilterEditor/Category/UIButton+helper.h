//
//  UIButton+helper.h
//  IOSNoCrop
//
//  Created by rcplatform on 29/4/14.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (helper)


- (void)setTitleForNormalAndHighlight:(NSString *)title;
- (void)setImageForNormalAndHighlight:(UIImage *)image;
- (void)setTitleColorForNormalAndHighlight:(UIColor *)color;

- (void)setImage:(NSString *)imageName WithTitle:(NSString *)title;
@end
