//
//  UIButton+helper.m
//  IOSNoCrop
//
//  Created by rcplatform on 29/4/14.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "UIButton+helper.h"

@implementation UIButton (helper)

- (void)setTitleForNormalAndHighlight:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
}

- (void)setImageForNormalAndHighlight:(UIImage *)image{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
}

- (void)setTitleColorForNormalAndHighlight:(UIColor *)color{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

- (void)setImage:(NSString *)imageName WithTitle:(NSString *)title{
    [self setImageForNormalAndHighlight:[UIImage imageNamed:imageName]];
    [self setTitleForNormalAndHighlight:title];
}

@end
