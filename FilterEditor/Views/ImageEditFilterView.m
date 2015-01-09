//
//  ImageEditFilterView.m
//  FilterGrid
//
//  Created by herui on 16/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "ImageEditFilterView.h"
#import "ImageEditFilterViewItem.h"
#import "FilterTypeHelper.h"
#import "FilterListView.h"
#import "ScrollView.h"
#import "CMethods.h"
#import "IS_Tools.h"
#import "PRJ_Global.h"
#import "FE_AdombView.h"

@interface ImageEditFilterView()<FilterListViewViewDelegate>
{
    ImageEditFilterViewItem *_currItem;
    UIScrollView *_filterGroupListView;
    FilterListView *_filterListView;
    NCFilterType _filterType;
    NSInteger _filterId;
    NSString *group_name;
}
@end

@implementation ImageEditFilterView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = colorWithHexString(@"#242424");
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockGroup:) name:UNLOCK_BW object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(installedAppligation) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        CGFloat scrollViewW = self.bounds.size.width;
        CGFloat scrollViewH = self.bounds.size.height;
        _filterGroupListView = [[ScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollViewW, scrollViewH)];
        _filterGroupListView.backgroundColor = colorWithHexString(@"#242424");
        [self addSubview:_filterGroupListView];
        
        CGFloat itemW = 92;
        CGFloat itemH = scrollViewH;
        NSArray *filterGroupNames = [FilterTypeHelper allGroupNames];
        
//        BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"RCFilterGrid://"]];
//        NSInteger number = 0;
//        if (installed)
//        {
//            number--;
//        }
        NSInteger count = filterGroupNames.count;
        
        for (int i=0; i < count; i++)
        {
            CGFloat itemX = i * itemW;
            ImageEditFilterViewItem *item = [[ImageEditFilterViewItem alloc] initWithFrame:CGRectMake(itemX, 0, itemW, itemH)];
            [_filterGroupListView addSubview:item];
            [item addTarget:self action:@selector(groupItemOnClick:) forControlEvents:UIControlEventTouchUpInside];
            item.tag = i;
            _filterGroupListView.contentSize = CGSizeMake(CGRectGetMaxX(item.frame), 0);
            item.itemName = filterGroupNames[i];
            item.image = jpgImagePath([NSString stringWithFormat:@"%@",filterGroupNames[i]]);
            NSMutableArray *arr = [[PRJ_Global shareStance].filterDictionary objectForKey:filterGroupNames[i]];
            
            if (arr && [arr count] > 0)
            {
                NSString *strColor = [arr objectAtIndex:0];
                item.lineColor = colorWithHexString([NSString stringWithFormat:@"#%@",strColor]);
            }
            
            item.nameLabel.hidden = NO;
            item.lockImageView.hidden = YES;
        }
        
        _filterListView = [[FilterListView alloc] initWithFrame:CGRectMake(0, scrollViewH, scrollViewW, scrollViewH)];
        _filterListView.backgroundColor = colorWithHexString(@"#2f2f2f");
        [self addSubview:_filterListView];
        _filterListView.delegate = self;
    }
    return self;
}

//- (void)installedAppligation
//{
//    BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"RCFilterGrid://"]];
//    if (installed)
//    {
//        for (ImageEditFilterViewItem *item in _filterGroupListView.subviews)
//        {
//            if (item.tag == 6)
//            {
//                [item removeFromSuperview];
//                [_filterGroupListView setContentSize:CGSizeMake(75 * 6, 0)];
//            }
//        }
//    }
//}

- (void)unlockGroup:(NSNotification *)notification
{
    for (ImageEditFilterViewItem *item in _filterGroupListView.subviews)
    {
        if (item.tag == 4 || item.tag == 5)
        {
            item.nameLabel.hidden = NO;
            item.lockImageView.hidden = YES;
        }
    }
}

- (void)groupItemOnClick:(ImageEditFilterViewItem *)groupItem
{
    _currItem.selected = NO;
    groupItem.selected = YES;
    _currItem = groupItem;
    
//    //解锁BW
//    if (([groupItem.itemName isEqualToString:@"BW"] || [groupItem.itemName isEqualToString:@"RETRO"]) && ![[[NSUserDefaults standardUserDefaults] objectForKey:UDKEY_ShareUnLock] boolValue])
//    {
//        if (_delegate && [_delegate respondsToSelector:@selector(imageEditFilterView:ChangeFilterId:)])
//        {
//            [_delegate imageEditFilterViewGroupName:groupItem.itemName];
//            return;
//        }
//    }
//
//    if ([groupItem.itemName isEqualToString:@"FilterGrid"])
//    {
//        FE_AdombView *admobView = [[FE_AdombView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//        [window addSubview:admobView];
//        
//        return;
//    }
    
    if ([groupItem.itemName isEqualToString:@"ORIGIN"])
    {
        [self filterListView:nil SelectedFilterId:0 itemTag:0];
        return;
    }
    
    NSArray *filterIDs = [FilterTypeHelper filtersInGroup:groupItem.itemName];
    _filterListView.filterIDs = filterIDs;
    [IS_Tools ViewAnimation:_filterListView withFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [IS_Tools ViewAnimation:_filterGroupListView withFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}

#pragma mark - FilterListViewViewDelegate
- (void)filterListView:(FilterListView *)filterListView SelectedFilterId:(NSInteger)filterId itemTag:(NSInteger)tag
{
    [PRJ_Global event:_currItem.itemName label:[NSString stringWithFormat:@"%@_%ld",_currItem.itemName,(long)tag]];
    _filterId = filterId;
    if (_delegate && [_delegate respondsToSelector:@selector(imageEditFilterView:ChangeFilterId:)])
    {
        [_delegate imageEditFilterView:self ChangeFilterId:_filterId];
    }
}

- (void)filterListViewRequsetReturn:(FilterListView *)filterListView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeHidden" object:nil];
    [IS_Tools ViewAnimation:_filterGroupListView withFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [IS_Tools ViewAnimation:_filterListView withFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}

- (void)secondTimeSelectListView
{
    if (_delegate && [_delegate respondsToSelector:@selector(secondTimeSelectListView)])
    {
        [_delegate secondTimeSelectListView];
    }
}

@end
