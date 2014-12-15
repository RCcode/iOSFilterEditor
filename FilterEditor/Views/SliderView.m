//
//  SliderView.m
//  FilterGrid
//
//  Created by TCH on 14-11-15.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "SliderView.h"
#import "CMethods.h"

@interface SliderView ()
{
    UIView *percentView;
    UILabel *lblNum;
    UIImageView *imgNumBg;
}
@end

@implementation SliderView

-(id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = colorWithHexString(@"#242424");
//        self.backgroundColor = [UIColor redColor];
//        percentView = [[UIView alloc] init];
//        percentView.backgroundColor = colorWithHexString(@"#242424");
//        percentView.backgroundColor = [UIColor orangeColor];
//        imgNumBg = [[UIImageView alloc]init];
//        [imgNumBg setImage:[UIImage imageNamed:@"fg_bg_Numerical_ progress bar"]];
//        [percentView addSubview:imgNumBg];
//        [self addSubview:percentView];
//        
//        lblNum = [[UILabel alloc]init];
//        lblNum.backgroundColor = [UIColor clearColor];
//        lblNum.textAlignment = NSTextAlignmentCenter;
//        lblNum.font = [UIFont systemFontOfSize:10];
//        lblNum.textColor = colorWithHexString(@"#ffffff");
//        [percentView addSubview:lblNum];
        
        _slider = [[UISlider alloc] init];
        UIImage *miniImage = [[UIImage imageNamed:@"fe_bg_whiteline_-progress-bar"]stretchableImageWithLeftCapWidth:20 topCapHeight:4];
        [_slider setMinimumTrackImage:miniImage forState:UIControlStateNormal];
        UIImage *maxImage =[[UIImage imageNamed:@"fe_bg_gray-line_-progress-bar"]stretchableImageWithLeftCapWidth:20 topCapHeight:4];
        [_slider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"fe_btn_Circle_ progress bar"] forState:UIControlStateNormal];
        [self addSubview:_slider];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_slider setFrame:CGRectMake(35, CGRectGetHeight(frame) - 70, CGRectGetWidth(frame) - 70, 35)];
    [percentView setFrame:CGRectMake(CGRectGetMinX(_slider.frame), CGRectGetHeight(frame)-60, CGRectGetWidth(_slider.frame), 30)];
    [lblNum setFrame:CGRectMake(0, 0, 20, 22)];
    lblNum.center = CGPointMake(10, CGRectGetHeight(percentView.frame)/2);
    imgNumBg.frame = lblNum.frame;
}

-(void)setValue:(float)value
{
    _value = value;
    _slider.value = value;
    lblNum.center = CGPointMake((CGRectGetWidth(percentView.frame)-CGRectGetWidth(lblNum.frame))*((value-_minimumValue)/(_maximumValue-_minimumValue))+CGRectGetWidth(lblNum.frame)/2, CGRectGetMidY(lblNum.frame));
    int num = (value-_minimumValue)/(_maximumValue-_minimumValue)*100;
    if (num >100)
    {
        num = 100;
    }
    [lblNum setText:[NSString stringWithFormat:@"%d",num]];
    imgNumBg.center = lblNum.center;
}

-(void)setMaximumValue:(float)maximumValue
{
    _maximumValue = maximumValue;
    _slider.maximumValue = _maximumValue;
}

-(void)setMinimumValue:(float)minimumValue
{
    _minimumValue = minimumValue;
    _slider.minimumValue = _minimumValue;
}

@end
