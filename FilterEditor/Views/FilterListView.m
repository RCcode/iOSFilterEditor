//
//  FilterListView.m
//  FilterGrid
//
//  Created by herui on 28/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "FilterListView.h"
#import "FilterListViewItem.h"
#import "ScrollView.h"
#import "FilterTypeHelper.h"
#import "EditViewController.h"
#import "CMethods.h"
#define kItemW 92


@interface FilterListView()
{
    UIScrollView *_scrollView;
    UIButton *_currItem;
    UIView *_currIrrView;
}
@end

@implementation FilterListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _scrollView = [[ScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = colorWithHexString(@"#242424");
        [self addSubview:_scrollView];
        
        //返回按钮
        CGFloat returnBtnW = 60;
        UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, (CGRectGetHeight(frame)-50)/2, returnBtnW-20, 50)];
        [returnBtn setImage:[UIImage imageNamed:@"fe_btn_back_On the cover_pressed"] forState:UIControlStateNormal];
        [returnBtn setImage:[UIImage imageNamed:@"fe_btn_back_On the cover_normal"] forState:UIControlStateHighlighted];
        [self addSubview:returnBtn];
        [returnBtn addTarget:self action:@selector(returnOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setFilterIDs:(NSArray *)filterIDs
{
    _filterIDs = filterIDs;
    
    for(UIButton *child in _scrollView.subviews)
    {
        if([child isKindOfClass:[UIButton class]])
        {
            [child removeFromSuperview];
        }
    }
    
    CGFloat itemH = self.bounds.size.height;
    for(int i=0; i<_filterIDs.count; i++)
    {
        CGFloat itemX = i * kItemW+60;
        FilterListViewItem *item = [[FilterListViewItem alloc] initWithFrame:CGRectMake(itemX, 0, kItemW, itemH)];
        [_scrollView addSubview:item];
        item.title = [_filterIDs[i] objectForKey:@"name"];
        item.filterId = [[_filterIDs[i] objectForKey:@"id"]integerValue];
        NSString *strColor = [_filterIDs[i] objectForKey:@"color"];
        item.tag = i;
        item.lineColor = colorWithHexString([NSString stringWithFormat:@"#%@",strColor]);

        [item addTarget:self action:@selector(itemOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _scrollView.contentSize = CGSizeMake(CGRectGetMaxX(item.frame), 0);
    }
}


#pragma mark - private methods
- (void)returnOnClick
{
    if([_delegate respondsToSelector:@selector(filterListViewRequsetReturn:)])
    {
        [_delegate filterListViewRequsetReturn:self];
    }
}

- (void)itemOnClick:(FilterListViewItem *)item
{
    if(![item isKindOfClass:[FilterListViewItem class]])
        return;
    UIView *irrgularView;
    if(_currItem == item)
    {
        if (item.filterId != 0 && _delegate && [_delegate respondsToSelector:@selector(secondTimeSelectListView)]&&_currIrrView == irrgularView)
        {
            [_delegate secondTimeSelectListView];
        }
    }
    
    _currIrrView = irrgularView;
    _currItem.selected = NO;
    item.selected = YES;
    _currItem = item;
    
    if (_delegate && [_delegate respondsToSelector:@selector(filterListView:SelectedFilterId:itemTag:)])
    {
        showLabelHUD(item.title);
        [_delegate filterListView:self SelectedFilterId:item.filterId itemTag:item.tag];
    }
}

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
