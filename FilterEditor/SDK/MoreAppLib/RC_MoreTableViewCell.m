//
//  Me_MoreTableViewCell.m
//  IOSMirror
//
//  Created by gaoluyangrc on 14-6-20.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.

#import "RC_MoreTableViewCell.h"

@implementation RC_MoreTableViewCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.logoImageView.layer.cornerRadius = 12.f;
    self.logoImageView.layer.masksToBounds = YES;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel sizeToFit];
    self.installLabel.layer.borderWidth = 1.f;
    self.installLabel.layer.cornerRadius = 4.f;
    self.installLabel.userInteractionEnabled = NO;
    self.installLabel.autoresizingMask = NO;
        
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)installBtnClick:(id)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.appInfo.openUrl]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appInfo.openUrl]];
    }
}

@end
