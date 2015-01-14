//
//  FilterListViewItem.m
//  FilterGrid
//
//  Created by herui on 28/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "FilterListViewItem.h"
#import "CMethods.h"
#import "IS_Tools.h"

@interface FilterListViewItem()
{
    UILabel *_titleLabel;
    UIImageView *_imageView;
    UIView *_selectView;
    UIView *_bottomLine;
    UIImageView *sliderImageView;
}
@end

@implementation FilterListViewItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, CGRectGetWidth(frame)-7, CGRectGetHeight(frame)-10)];
        [self addSubview:_imageView];
        
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame)-17, CGRectGetWidth(_imageView.frame), 17)];
        [self addSubview:_bottomLine];
        
        _titleLabel = [[UILabel alloc] initWithFrame:_bottomLine.frame];
        [self addSubview:_titleLabel];
        [_titleLabel setTextColor:colorWithHexString(@"#ffffff")];
        _titleLabel.shadowColor = [colorWithHexString(@"#000000") colorWithAlphaComponent:0.3];
        _titleLabel.shadowOffset = CGSizeMake(0, 1);
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _selectView = [[UIView alloc]initWithFrame:_imageView.frame];
        _selectView.userInteractionEnabled = NO;
        [self addSubview:_selectView];
        sliderImageView = [[UIImageView alloc]initWithFrame:_selectView.bounds];
        [sliderImageView setImage:[UIImage imageNamed:@"fe_icon_Small_On the cover"]];
        sliderImageView.contentMode = UIViewContentModeCenter;
        [_selectView addSubview:sliderImageView];
        _selectView.alpha = 0;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = _title;
}

-(void)setFilterId:(NSInteger)filterId
{
    _filterId = filterId;
    if(_filterId != 0)
    {
        [_imageView setImage:jpgImagePath([NSString stringWithFormat:@"com_rcplatform_filter_%d",(int)_filterId])];
    }
    else
    {
        [_imageView setImage:jpgImagePath([NSString stringWithFormat:@"com_rcplatform_filter_%@",_title])];
        _title = @"origin";
        _titleLabel.text = _title;
    }
}

-(void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    [_bottomLine setBackgroundColor:_lineColor];
    _selectView.backgroundColor = [_lineColor colorWithAlphaComponent:0.3];
}

-(void)setSelected:(BOOL)selected
{
    [IS_Tools viewFadeAnimation:_selectView fadeIn:selected];
    if(selected)
    {
        sliderImageView.hidden = NO;
    }
    else
    {
        sliderImageView.hidden = YES;
    }
}

@end
