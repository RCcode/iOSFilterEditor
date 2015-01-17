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
#import "CMethods.h"
#import "XHMenu.h"
#import "XHScrollMenu.h"
#define kItemW 92


@interface FilterListView() <XHScrollMenuDelegate>
{
    UIButton *_currItem;
    UIView *_currIrrView;
    XHScrollMenu *xh_scrollView;
}
@end

@implementation FilterListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        xh_scrollView = [[XHScrollMenu alloc] initWithFrame:self.bounds];
        xh_scrollView.backgroundColor = colorWithHexString(@"#242424");
        xh_scrollView.delegate = self;
        [self addSubview:xh_scrollView];
        
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
    
    CGFloat itemH = self.bounds.size.height;

    NSMutableArray *menus = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < _filterIDs.count; i ++)
    {
        CGFloat itemX = i * kItemW+60;
        XHMenu *menu = [[XHMenu alloc] init];
        CGRect rect = CGRectMake(itemX, 0, kItemW, itemH);
        menu.origin_rect = rect;
        NSInteger filterID = [[_filterIDs[i] objectForKey:@"id"]integerValue];
        menu.filterId = filterID;
        menu.title = [_filterIDs[i] objectForKey:@"name"];
        NSString *strColor = [_filterIDs[i] objectForKey:@"color"];
        menu.lineColor = colorWithHexString([NSString stringWithFormat:@"#%@",strColor]);
        [menus addObject:menu];
    }
    
    [xh_scrollView.scrollView setContentOffset:CGPointMake(0, 0)];
    xh_scrollView.menus = menus;
    [xh_scrollView reloadData];
}

- (void)scrollMenuDidSelected:(XHScrollMenu *)scrollMenu menuBtn:(id)selectBtn
{
    FilterListViewItem *button = (FilterListViewItem *)selectBtn;
    if(![button isKindOfClass:[FilterListViewItem class]])
        return;
    UIView *irrgularView;
    //弹出强度调节工具栏
    if(_currItem == button)
    {
        if (button.filterId != 0 && _delegate && [_delegate respondsToSelector:@selector(secondTimeSelectListView)]&&_currIrrView == irrgularView)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTools" object:nil];
            [_delegate secondTimeSelectListView];
        }
    }
    
    _currIrrView = irrgularView;
    _currItem.selected = NO;
    button.selected = YES;
    _currItem = button;
    
    if (_delegate && [_delegate respondsToSelector:@selector(filterListView:SelectedFilterId:itemTag:)])
    {
        showLabelHUD(button.title);
        [_delegate filterListView:self SelectedFilterId:button.filterId itemTag:button.tag];
    }
}

- (void)scrollMenuDidManagerSelected:(XHScrollMenu *)scrollMenu
{
    
}

#pragma mark - private methods
- (void)returnOnClick
{
    if([_delegate respondsToSelector:@selector(filterListViewRequsetReturn:)])
    {
        [_delegate filterListViewRequsetReturn:self];
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
