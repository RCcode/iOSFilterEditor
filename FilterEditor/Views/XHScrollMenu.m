//
//  XHScrollMenu.m
//  XHScrollMenu
//
//  Created by 曾 宪华 on 14-3-8.
//  Copyright (c) 2014年 曾宪华 QQ群: (142557668) QQ:543413507  Gmail:xhzengAIB@gmail.com. All rights reserved.
//

#import "XHScrollMenu.h"
#import "FilterListViewItem.h"
#import "UIScrollView+XHVisibleCenterScroll.h"
#import "PRJ_Global.h"

#define kXHMenuButtonBaseTag 100

@interface XHScrollMenu () <UIScrollViewDelegate>
{
    FilterListViewItem *current_btn;
}

@property (nonatomic, strong) NSMutableArray *menuButtons;

@end

@implementation XHScrollMenu

#pragma mark - Propertys

- (NSMutableArray *)menuButtons
{
    if (!_menuButtons)
    {
        _menuButtons = [[NSMutableArray alloc] initWithCapacity:self.menus.count];
    }
    return _menuButtons;
}

#pragma mark - Action
- (void)managerMenusButtonClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(scrollMenuDidManagerSelected:)])
    {
        [self.delegate scrollMenuDidManagerSelected:self];
    }
}

- (void)menuButtonSelected:(FilterListViewItem *)sender
{
    [self.menuButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj == sender) {
            current_btn = sender;
        } else {
            FilterListViewItem *menuButton = obj;
            menuButton.selected = NO;
        }
    }];
    [self setSelectedIndex:sender.tag - kXHMenuButtonBaseTag animated:YES calledDelegate:YES];
}

- (void)setup
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _selectedIndex = 0;

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    [self addSubview:self.scrollView];
}

- (void)setupIndicatorFrame:(CGRect)menuButtonFrame animated:(BOOL)animated callDelegate:(BOOL)called {
    if (called)
    {
        if ([self.delegate respondsToSelector:@selector(scrollMenuDidSelected:menuBtn:)])
        {
            FilterListViewItem *button = (FilterListViewItem *)[_scrollView viewWithTag:_selectedIndex + kXHMenuButtonBaseTag];
            [self.delegate scrollMenuDidSelected:self menuBtn:button];
        }
    }
}

- (UIButton *)getButtonWithMenu:(XHMenu *)menu
{
    FilterListViewItem *button = [[FilterListViewItem alloc] initWithFrame:menu.origin_rect];
    button.filterId = menu.filterId;
    button.title = menu.title;
    button.lineColor = menu.lineColor;
    [button addTarget:self action:@selector(menuButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        //侦听scroller滑动停止事件
        [[PRJ_Global shareStance] selectedFilterID:^(NSInteger filterIndex) {
            NSInteger index = filterIndex - 1;
            if (index == -1)
            {
                index = self.menuButtons.count - 1;
            }
            FilterListViewItem *button = self.menuButtons[index];
            [self menuButtonSelected:button];
        }];
    }
    return self;
}

#pragma mark - Public
- (CGRect)rectForSelectedItemAtIndex:(NSUInteger)index
{
    CGRect rect = ((UIView *)self.menuButtons[index]).frame;
    return rect;
}

- (UIButton *)menuButtonAtIndex:(NSUInteger)index
{
    return self.menuButtons[index];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)aniamted calledDelegate:(BOOL)calledDelgate
{
    _selectedIndex = selectedIndex;
    UIButton *selectedMenuButton = [self menuButtonAtIndex:_selectedIndex];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.scrollView scrollRectToVisibleCenteredOn:selectedMenuButton.frame animated:NO];
    } completion:^(BOOL finished) {
        current_btn.selected = YES;
        [self setupIndicatorFrame:selectedMenuButton.frame animated:aniamted callDelegate:calledDelgate];
    }];
}

- (void)reloadData
{
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIView class]])
        {
            [((UIView *)obj) removeFromSuperview];
        }
    }];
    if (self.menuButtons.count)
        [self.menuButtons removeAllObjects];
    
    CGFloat contentWidth = 10;
    for (XHMenu *menu in self.menus)
    {
        NSUInteger index = [self.menus indexOfObject:menu];
        UIButton *menuButton = [self getButtonWithMenu:menu];
        menuButton.tag = kXHMenuButtonBaseTag + index;
        CGRect menuButtonFrame = menuButton.frame;

        [self.scrollView addSubview:menuButton];
        [self.menuButtons addObject:menuButton];
        
        if (index == self.menus.count - 1)
        {
            contentWidth += CGRectGetMaxX(menuButtonFrame);
        }
        
        if (self.selectedIndex == index)
        {
            [self setupIndicatorFrame:menuButtonFrame animated:NO callDelegate:NO];
        }
    }
    [self.scrollView setContentSize:CGSizeMake(contentWidth, CGRectGetHeight(self.scrollView.frame))];
}

@end
