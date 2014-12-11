//
//  IS_LoadingView.h
//  iOSNoCropVideo
//
//  Created by TCH on 14-9-22.
//  Copyright (c) 2014年 com.rcplatformhk. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface IS_LoadingView : UIView

- (void)setLaberString:(NSString *)strLabel;
- (void)setProcess:(float)process;
- (void)startAnimating;
- (void)stopAnimating;

@end
