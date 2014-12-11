//
//  PRJ_Button.m
//  IOSNoCrop
//
//  Created by rcplatform on 14-4-19.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "ME_Button.h"
#import "CMethods.h"
#import "PRJ_Global.h"

@implementation ME_Button

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.toolImageView = [[UIImageView alloc]init];
        [self addSubview:self.toolImageView];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.contentLabel];
    }
    return self;
}

- (void)setIsTurn:(BOOL)isTurn
{
    _isTurn = isTurn;
    if (_isTurn)
    {
        self.toolImageView.image = [UIImage imageNamed:self.selectName];
        _record = self.tag;
    }
    else
    {
        if (self.tag == 2)
        {
            self.toolImageView.image = [UIImage imageNamed:@"fe_icon_3.2_pressed"];
        }
        else if (self.tag == 3)
        {
            self.toolImageView.image = [UIImage imageNamed:@"fe_icon_4.3_pressed"];
        }
        else if (self.tag == 4)
        {
            self.toolImageView.image = [UIImage imageNamed:@"fe_icon_16.9_pressed"];
        }
        _record = self.tag + 3;
    }
}

- (void)setNormelName:(NSString *)normelName
{
    _normelName = normelName;
    self.toolImageView.image = [UIImage imageNamed:normelName];
    self.backgroundColor = [UIColor clearColor];
    self.contentLabel.textColor = [UIColor whiteColor];
}

- (void)changeBtnImage
{
    self.toolImageView.image = [UIImage imageNamed:self.selectName];
    self.contentLabel.textColor = colorWithHexString(@"#D9AF20");
    self.backgroundColor = colorWithHexString(@"#000000");
}

- (void)btnHaveClicked
{
    self.toolImageView.image = [UIImage imageNamed:self.normelName];
    self.backgroundColor = [UIColor clearColor];
    self.contentLabel.textColor = [UIColor whiteColor];
}

@end
