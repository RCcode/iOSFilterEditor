//
//  ImageEditAdjustViewBottomBar.m
//  FilterGrid
//
//  Created by herui on 16/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "ImageEditAdjustViewBottomBar.h"
#import "CMethods.h"

@interface ImageEditAdjustViewBottomBar()
{
    UIButton *_currItem;
}
@end

@implementation ImageEditAdjustViewBottomBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = colorWithHexString(@"#282828");
        
        // Initialization code
//        NSArray *titles = @[@"亮度", @"对比度", @"饱和度", @"色温", @"锐化"];
//        NSArray *titles = @[@"fg_icon_Brightness", @"fg_icon_Contrast", @"fg_icon_Saturation", @"fg_icon_Color temperature", @"fg_icon_Sharpening"];
        NSArray *titles = @[@"fg_icon_Brightness", @"fg_icon_Contrast", @"fg_icon_Saturation"];
        CGFloat itemW = self.bounds.size.width / kImageAdjustItemTypeTotalNumber;
        CGFloat itemH = self.bounds.size.height;
        
        for (int i=kImageAdjustItemTypeBrightness; i<kImageAdjustItemTypeTotalNumber; i++) {
            NSString *title = titles[i];
            CGFloat itemX = i * itemW;
            UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(itemX, 0, itemW, itemH)];
            [self addSubview:item];
            [item setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed",title]] forState:UIControlStateSelected];
            [item setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",title]] forState:UIControlStateNormal];
            [item addTarget:self action:@selector(itemOnClick:) forControlEvents:UIControlEventTouchUpInside];
            item.tag = i;
            if(i == 0){
                [self itemOnClick:item];
            }
        }
        
    }
    return self;
}

- (void)itemOnClick:(UIButton *)item{
    
    _currItem.selected = NO;
    item.selected = YES;
    _currItem = item;
    
    if([_delegate respondsToSelector:@selector(imageEditAdjustViewBottomBar:DidSelectTyep:)]){
        [_delegate imageEditAdjustViewBottomBar:self DidSelectTyep:(ImageAdjustItemType)item.tag];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
