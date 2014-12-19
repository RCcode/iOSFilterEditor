//
//  FE_AdombView.m
//  FilterEditor
//
//  Created by gaoluyangrc on 14-12-11.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "FE_AdombView.h"
#import "CMethods.h"

@implementation FE_AdombView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView *backGroudView = [[UIView alloc] initWithFrame:self.bounds];
        backGroudView.backgroundColor = [UIColor blackColor];
        backGroudView.alpha = 0.3f;
        [self addSubview:backGroudView];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 207, 355)];
        backView.layer.cornerRadius = 6.f;
        backView.layer.masksToBounds = YES;
        backView.center = self.center;
        [self addSubview:backView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 207, 310)];
        imageView.backgroundColor = [UIColor redColor];
        imageView.image = [UIImage imageNamed:@"fe_bg_1@2x.jpg"];
        [backView addSubview:imageView];
        
        UIButton *cancel_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel_btn.tag = 1;
        [cancel_btn setFrame:CGRectMake(0, 310, 103.5f, 45.f)];
        [cancel_btn setTitle:LocalizedString(@"cancel", nil) forState:UIControlStateNormal];
        [cancel_btn setBackgroundColor:colorWithHexString(@"#fbfbfb")];
        [cancel_btn setTitleColor:colorWithHexString(@"#636363") forState:UIControlStateNormal];
        [cancel_btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:cancel_btn];
        
        UIButton *downLoad_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        downLoad_btn.tag = 2;
        [downLoad_btn setFrame:CGRectMake(103.5f, 310, 103.5f, 45.f)];
        [downLoad_btn setTitle:LocalizedString(@"go_to_downLoad", nil) forState:UIControlStateNormal];
        [downLoad_btn setBackgroundColor:colorWithHexString(@"#fbfbfb")];
        [downLoad_btn setTitleColor:colorWithHexString(@"#499bca") forState:UIControlStateNormal];
        [downLoad_btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:downLoad_btn];
        
        UIView *line_view = [[UIView alloc] initWithFrame:CGRectMake(103.5f, 310, 1.f, 45.f)];
        line_view.backgroundColor = colorWithHexString(@"#e0e0e0");
        [backView addSubview:line_view];
    }
    return self;
}

- (void)buttonClick:(UIButton *)btn
{
    if (btn.tag == 2)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",kFilterGridAppID]]];
    }
    [self removeFromSuperview];
}

@end
