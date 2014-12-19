//
//  ImageEditTopBar.m
//  FilterGrid
//
//  Created by herui on 16/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "ImageEditTopBar.h"
#import "CMethods.h"

@interface ImageEditTopBar()
{
    UIButton *_currItem;
}
@end

@implementation ImageEditTopBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = colorWithHexString(@"#1f1f1f");
        NSArray *titles = @[@"fg_icon_fx", @"fg_icon_Regulation", @"fg_icon_ok"];
        
        CGFloat itemW = CGRectGetWidth(frame)/titles.count;
        CGFloat itemH = self.bounds.size.height;
        
        for (int i=0; i<titles.count; i++)
        {
            NSString *title = titles[i];
            CGFloat itemX = i * itemW;
            UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(itemX, 0, itemW, itemH)];
            [self addSubview:item];
            [item setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed",title]] forState:UIControlStateSelected];
            [item setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",title]] forState:UIControlStateNormal];
            [item addTarget:self action:@selector(itemOnClick:) forControlEvents:UIControlEventTouchUpInside];
            item.tag = i;
            if(i == 0)
            {
                [self itemOnClick:item];
            }
        }
    }
    return self;
}

- (void)itemOnClick:(UIButton *)item
{
    if(item.tag != kImageEditTopBarItemTypeConfirm)
    {
        _currItem.selected = NO;
        item.selected = YES;
        _currItem = item;
    }
    
    if([_delegate respondsToSelector:@selector(imageEditTopBar:DidSelectItemWithType:)])
    {
        [_delegate imageEditTopBar:self DidSelectItemWithType:(ImageEditTopBarItemType)item.tag];
    }
}

@end
