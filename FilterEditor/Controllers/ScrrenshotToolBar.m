//
//  ScrrenshotToolBar.m
//  FilterGrid
//
//  Created by herui on 5/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "ScrrenshotToolBar.h"
#import "ToolBarItem.h"
#import "CMethods.h"
#import "ME_Button.h"

@interface ScrrenshotToolBar()
{
    NSArray *titles;
}
@end

@implementation ScrrenshotToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = colorWithHexString(@"#1f1f1f");
        
        titles = @[@"free", @"1:1", @"2:3", @"3:4", @"9:16" ,@"3:2" ,@"4:3" ,@"16:9"];
        NSArray *normals = @[@"fe_icon_free_normal",@"fe_icon_1_1_normal",@"fe_icon_2_3_normal",@"fe_icon_3_4_normal",@"fe_icon_9_16_normal"];
        NSArray *selects = @[@"fe_icon_free_pressed",@"fe_icon_1_1_pressed",@"fe_icon_2_3_pressed",@"fe_icon_3_4_pressed",@"fe_icon_9_16_pressed"];
        
        CGFloat itemH = frame.size.height;
        CGFloat itemW = frame.size.width / 5;
        CGFloat imageW = 28;
        CGFloat imageH = 28;
        for (AspectRatio i = kAspectRatioFree; i < 5; i++)
        {
            CGFloat itemX = i * itemW;
            ME_Button *item = [[ME_Button alloc] initWithFrame:CGRectMake(itemX, 0, itemW, itemH)];
            item.tag = i;
            item.record = i;
            [item.toolImageView setFrame:CGRectMake((itemW - imageW)/2.f, 5, imageW, imageH)];
            item.normelName = normals[i];
            item.selectName = selects[i];
            [item.contentLabel setFrame:CGRectMake(0, 36, itemW, 14)];
            item.contentLabel.font = [UIFont systemFontOfSize:11.f];
            item.contentLabel.textColor = colorWithHexString(@"#878787");
            item.contentLabel.text = titles[i];
            [item addTarget:self action:@selector(itemOnClick:) forControlEvents:UIControlEventTouchUpInside];

            if(i == 0)
            {
                [item changeBtnImage];
            }
            [self addSubview:item];
        }
    }
    return self;
}

- (void)itemOnClick:(ME_Button *)item
{
    for (ME_Button *btn in [self subviews])
    {
        if (item.tag != btn.tag)
        {
            btn.isTurn = NO;
            btn.record = btn.tag;
            btn.contentLabel.text = titles[btn.record];
        }
        [btn btnHaveClicked];
    }
    
    if (item.tag > 1)
    {
        item.isTurn = !item.isTurn;
        item.contentLabel.text = titles[item.record];
    }
    else
    {
        [item changeBtnImage];
    }

    if([_delegate respondsToSelector:@selector(scrrenshotToolBar:ItemOnClick:)])
    {
        [_delegate scrrenshotToolBar:self ItemOnClick:(AspectRatio)item.record];
    }
}

@end
