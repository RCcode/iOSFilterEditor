//
//  RCGuideView.m
//  IOSMirror
//
//  Created by gaoluyangrc on 15-1-6.
//  Copyright (c) 2015年 rcplatformhk. All rights reserved.
//

#import "CMethods.h"
#import "RCGuideView.h"

@implementation RCGuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect backRect,guideRect;
        if (kScreen5_5)
        {
            backRect = CGRectMake(0, 0, 246.3f, 246.3f);
            guideRect = CGRectMake(CGRectGetWidth(backRect)/2.f - 53.35f, CGRectGetHeight(backRect) - 106.7f - 54.f, 106.7f, 106.7f);
        }
        else
        {
            backRect = CGRectMake(0, 0, 225.f, 226.f);
            guideRect = CGRectMake(CGRectGetWidth(backRect)/2.f - 48.f, CGRectGetHeight(backRect) - 96.f - 50.f, 96.f, 96.f);
        }
        UIView *backView = [[UIView alloc] initWithFrame:backRect];
        backView.layer.cornerRadius = 8.f;
        backView.userInteractionEnabled = NO;
        backView.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.f);
        backView.backgroundColor = colorWithHexString(@"#000000");
        backView.alpha = 0.75f;
        [self addSubview:backView];
        
        UIImageView *guideImageView = [[UIImageView alloc] initWithFrame:guideRect];
        guideImageView.image = [UIImage imageNamed:@"fg_Pop_Mobile"];
        [backView addSubview:guideImageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(CGRectGetWidth(backView.frame) - 12.f, -12.f, 24, 24);
        [button setImage:[UIImage imageNamed:@"fe_Pop_x_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"fe_Pop_x_pressed"] forState:UIControlStateHighlighted];
        [backView addSubview:button];
        
#warning 多语言
        NSString *string = @"Slide left or right to randomly switch filters";
        CGSize size = sizeWithContentAndFont(string, CGSizeMake(kScreen5_5 ? 207.f : 185.f, 1000),kScreen5_5 ? 25.f : 15.f);
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, kScreen5_5 ? 27.f : 23.f, size.width, size.height)];
        detailLabel.center = CGPointMake(kScreen5_5 ? 123.2f : 112.5f, CGRectGetMinY(detailLabel.frame) + size.height/2.f);
        detailLabel.numberOfLines = 0;
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        detailLabel.text = string;
        detailLabel.textColor = colorWithHexString(@"#ffffff");
        detailLabel.font = [UIFont systemFontOfSize:kScreen5_5 ? 25.f : 15.f];
        [backView addSubview:detailLabel];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeCurrentView];
}

- (void)removeCurrentView
{
    [self removeFromSuperview];
}

@end
