//
//  ScrollView.m
//  IOSNoCrop
//
//  Created by herui on 23/9/14.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseMoved) {
        return NO;
    }
    return [super touchesShouldBegin:touches withEvent:event inContentView:view];
}

@end
