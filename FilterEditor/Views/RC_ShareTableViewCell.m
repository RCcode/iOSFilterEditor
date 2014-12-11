//
//  RC_ShareTableViewCell.m
//  IOSMirror
//
//  Created by gaoluyangrc on 14-10-17.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "RC_ShareTableViewCell.h"
#import "CMethods.h"

@implementation RC_ShareTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(float)height
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
        self.backgroundColor = colorWithHexString(@"#2f2f2f");
        //底图
        _bottom_view = [[UIView alloc] initWithFrame:CGRectMake(8, 0, 304, height - 15)];
        _bottom_view.backgroundColor = colorWithHexString(@"#474747");
        _bottom_view.layer.cornerRadius = 10.f;
        [self.contentView addSubview:_bottom_view];
        
        //logo
        _app_logo_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, iPhone4() ? 9 : 38, 70, 70)];
        [_bottom_view addSubview:_app_logo_imageView];
        
        //应用名称
        _app_title_label = [[UILabel alloc] initWithFrame:CGRectMake(97, iPhone4() ? 9 : 38, 180, 40)];
        _app_title_label.font = [UIFont boldSystemFontOfSize:20.f];
        [_bottom_view addSubview:_app_title_label];
        
        //应用描述
        _app_detail_label = [[UILabel alloc] initWithFrame:CGRectMake(97, iPhone4() ? 29 : 63, 180, iPhone4() ? 50 : 63)];
        _app_detail_label.font = [UIFont boldSystemFontOfSize:14.f];
        _app_detail_label.numberOfLines = 0;
        _app_detail_label.lineBreakMode = NSLineBreakByWordWrapping;
        [_bottom_view addSubview:_app_detail_label];
        
        //宣传图
        _app_bander_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, iPhone4() ? 87 : 108, 290, height - 108)];
        _app_bander_imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_bottom_view addSubview:_app_bander_imageView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
