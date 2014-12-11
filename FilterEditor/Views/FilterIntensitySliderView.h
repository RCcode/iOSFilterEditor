//
//  FilterIntensitySliderView.h
//  FilterGrid
//
//  Created by TCH on 14-11-4.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderView.h"

@interface FilterIntensitySliderView : UIView

@property (nonatomic, strong) SliderView *sliderView;
@property (nonatomic, assign) float startValue;
@property (nonatomic, assign) float endValue;
@property (nonatomic, assign) float currentValue;

- (void)setCloseBlock:(void (^)(BOOL isCross))closeBlock;

@end
