//
//  IS_LoadingView.m
//  iOSNoCropVideo
//
//  Created by TCH on 14-9-22.
//  Copyright (c) 2014年 com.rcplatformhk. All rights reserved.
//

#import "IS_LoadingView.h"

@interface IS_LoadingView ()
{
    NSTimer *timer;
    CABasicAnimation *animation;
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *progressLabel;
@end

@implementation IS_LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [_bgView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
        _bgView.hidden = YES;
        [self addSubview:_bgView];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
        _imageView.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
        _imageView.image = [UIImage imageNamed:@"loading"];
        _imageView.hidden = YES;
        [self addSubview:_imageView];
        
        self.progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 100)];
        [_progressLabel setTextColor:[UIColor whiteColor]];
        [_progressLabel setFont:[UIFont boldSystemFontOfSize:35]];
        [_progressLabel setCenter:_imageView.center];
        [_progressLabel setBackgroundColor:[UIColor clearColor]];
        [_progressLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_progressLabel];
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame), CGRectGetWidth(frame), 40)];
        [_label setTextColor:[UIColor whiteColor]];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [_label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_label];
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0, 0, 1.0)];
        //执行时间
        animation.duration = 0.5;
        animation.cumulative = YES;//累积的
        //执行次数
        animation.repeatCount = INT_MAX;
        animation.autoreverses=NO;//是否自动重复
        
        self.userInteractionEnabled = YES;

    }
    return self;
}

- (void)setLaberString:(NSString *)strLabel
{
    [_label setText:strLabel];
}

-(void)setProcess:(float)process
{
    NSLog(@"aaaaa%f",process);
    if (process>0) {
        [_progressLabel setText:[NSString stringWithFormat:@"%d%%",(int)(process*100)]];
    }
    else
    {
        [_progressLabel setText:nil];
    }
}

- (void)startAnimating
{
    [_imageView.layer addAnimation:animation forKey:@"rotateAnimation"];
    _imageView.hidden = NO;
    _bgView.hidden = NO;
    self.hidden = NO;
}

- (void)stopAnimating
{
    [_imageView.layer removeAnimationForKey:@"rotateAnimation"];
    _imageView.hidden = YES;
    _bgView.hidden = YES;
    self.hidden = YES;
}

- (void)rotateView
{
    _imageView.transform = CGAffineTransformRotate(_imageView.transform, M_PI_4 * 0.1);
}

@end
