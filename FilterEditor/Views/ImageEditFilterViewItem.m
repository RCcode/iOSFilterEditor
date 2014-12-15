//
//  ImageEditFilterViewItem.m
//  FilterGrid
//
//  Created by herui on 16/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "ImageEditFilterViewItem.h"
#import "CMethods.h"

@interface ImageEditFilterViewItem()
{
    UIImageView *_imageView;
    UIView *_bottomLine;
    UIView *_selectView;
}
@end

@implementation ImageEditFilterViewItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 10, CGRectGetWidth(frame) - 8, CGRectGetHeight(frame)- 20)];
        [self addSubview:_imageView];
        
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(_imageView.frame) - 9, CGRectGetWidth(_imageView.frame), 9)];
        [self addSubview:_bottomLine];
        
        _selectView = [[UIView alloc]initWithFrame:_imageView.frame];
        _selectView.userInteractionEnabled = NO;
        [self addSubview:_selectView];
        _selectView.hidden = YES;
        
        _nameLabel = [[UILabel alloc] initWithFrame:_imageView.frame];
        [self addSubview:_nameLabel];
        [_nameLabel setTextColor:colorWithHexString(@"#ffffff")];
        _nameLabel.shadowColor = [colorWithHexString(@"#000000") colorWithAlphaComponent:0.3];
        _nameLabel.shadowOffset = CGSizeMake(0, 1);
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        
        //锁
        _lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _lockImageView.center = _imageView.center;
        _lockImageView.contentMode = UIViewContentModeCenter;
        _lockImageView.image = [UIImage imageNamed:@"fe_icon_Lock"];
        _lockImageView.hidden = YES;
        _lockImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [self addSubview:_lockImageView];
    }
    return self;
}

- (void)setItemName:(NSString *)itemName{
    _itemName = itemName;
    
    _nameLabel.text = _itemName;
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = _image;
}

-(void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    [_bottomLine setBackgroundColor:_lineColor];
    _selectView.backgroundColor = [_lineColor colorWithAlphaComponent:0.3];
}

-(void)setSelected:(BOOL)selected
{
    _selectView.hidden = !selected;
}

@end
