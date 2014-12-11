//
//  SliderView.h
//  FilterGrid
//
//  Created by TCH on 14-11-15.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderView : UIView

@property(nonatomic) float value;  

@property (nonatomic, strong)UISlider *slider;

@property(nonatomic) float minimumValue;
@property(nonatomic) float maximumValue;

@end
