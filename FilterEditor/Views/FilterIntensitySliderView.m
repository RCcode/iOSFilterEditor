//
//  FilterIntensitySliderView.m
//  FilterGrid
//
//  Created by TCH on 14-11-4.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "FilterIntensitySliderView.h"
#import "CMethods.h"
#import "ME_Button.h"

@interface FilterIntensitySliderView ()
{
    UIView *_bottomView;
    CGRect _frame;
}

@property (nonatomic,copy) void (^ close)(BOOL isCross);

@end

@implementation FilterIntensitySliderView

- (id)initWithFrame:(CGRect)frame
{
    _frame = frame;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = colorWithHexString(@"#242424");
                
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame), CGRectGetWidth(frame), 0)];
        [_bottomView setBackgroundColor:colorWithHexString(@"#1f1f1f")];
        [self addSubview:_bottomView];
        
        _sliderView = [[SliderView alloc]init];
        [_sliderView setFrame:CGRectMake(0, (CGRectGetHeight(frame) - 60)/2, CGRectGetWidth(frame), 60)];
        [self addSubview:_sliderView];
        [self setFrame:CGRectMake(CGRectGetMinX(_frame), CGRectGetMaxY(_frame), CGRectGetWidth(_frame), CGRectGetHeight(_frame))];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_frame) - 50, windowWidth(), 50)];
        [backView setBackgroundColor:colorWithHexString(@"#131313")];
        [self addSubview:backView];
        
        ME_Button *cross_btn = [[ME_Button alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(frame)/2.f, 40)];
        cross_btn.tag = 1;
        [cross_btn.toolImageView setFrame:CGRectMake(0, 0, 28, 28)];
        [cross_btn.toolImageView setCenter:CGPointMake(CGRectGetWidth(cross_btn.frame)*(1.f/2.f), CGRectGetHeight(cross_btn.frame)/2.f)];
        cross_btn.normelName = @"fe_icon_no_normal";
        cross_btn.selectName = @"fe_icon_no_pressed";
        [cross_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cross_btn btnHaveClicked];
        [backView addSubview:cross_btn];
        
        ME_Button *check_btn = [[ME_Button alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/2.f, 5, CGRectGetWidth(frame)/2.f, 40)];
        check_btn.tag = 2;
        [check_btn.toolImageView setFrame:CGRectMake(0, 0, 28, 28)];
        [check_btn.toolImageView setCenter:CGPointMake(CGRectGetWidth(check_btn.frame)*(1.f/2.f), CGRectGetHeight(check_btn.frame)/2.f)];
        check_btn.normelName = @"fe_icon_ok_normal";
        check_btn.selectName = @"fe_icon_ok_pressed";
        [check_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [check_btn btnHaveClicked];
        [backView addSubview:check_btn];
        
        UIView *line_view = [[UIView alloc] initWithFrame:CGRectMake(windowWidth()/2.f - 1.f, 0, 2, backView.bounds.size.height)];
        line_view.backgroundColor = colorWithHexString(@"#242424");
        [backView addSubview:line_view];
    }
    return self;
}

- (void)btnClick:(ME_Button *)btn
{
    BOOL isCross = NO;
    if (btn.tag == 1)
    {
        isCross = YES;
    }
    else if (btn.tag == 2)
    {
        isCross = NO;
    }
    
    if (_close)
    {
        _close(isCross);
    }
}

- (void)setCloseBlock:(void (^)(BOOL isCross))closeBlock
{
    _close = closeBlock;
}

-(void)setEndValue:(float)endValue
{
    _endValue = endValue;
    _sliderView.maximumValue = _endValue;
}

-(void)setStartValue:(float)startValue
{
    _startValue = startValue;
    _sliderView.minimumValue = _startValue;
}

-(void)setCurrentValue:(float)currentValue
{
    _currentValue = currentValue;
    _sliderView.value = _currentValue;
}

@end
