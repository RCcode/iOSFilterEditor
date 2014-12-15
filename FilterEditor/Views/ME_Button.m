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
        self.contentLabel.textColor = colorWithHexString(@"#ffffff");
        _record = self.tag;
    }
    else
    {
        if (self.tag == 2)
        {
            self.toolImageView.image = [UIImage imageNamed:@"fe_icon_3_2_pressed"];
        }
        else if (self.tag == 3)
        {
            self.toolImageView.image = [UIImage imageNamed:@"fe_icon_4_3_pressed"];
        }
        else if (self.tag == 4)
        {
            self.toolImageView.image = [UIImage imageNamed:@"fe_icon_16_9_pressed"];
        }
        _record = self.tag + 3;
        self.contentLabel.textColor = colorWithHexString(@"#ffffff");
    }
}

- (void)setNormelName:(NSString *)normelName
{
    _normelName = normelName;
    UIImage *image = [UIImage imageNamed:_normelName];
    self.toolImageView.image = image;
    self.backgroundColor = [UIColor clearColor];
    self.contentLabel.textColor = colorWithHexString(@"#878787");
}

- (void)changeBtnImage
{
    UIImage *image = [UIImage imageNamed:self.selectName];
    self.toolImageView.image = image;
    self.contentLabel.textColor = colorWithHexString(@"#ffffff");
    self.backgroundColor = colorWithHexString(@"#000000");
}

- (void)btnHaveClicked
{
    self.toolImageView.image = [UIImage imageNamed:self.normelName];
    self.backgroundColor = [UIColor clearColor];
    self.contentLabel.textColor = colorWithHexString(@"#878787");
}

@end
