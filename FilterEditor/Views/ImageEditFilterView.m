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

@interface ImageEditFilterView()<FilterListViewViewDelegate>
{
    UIButton *_currItem;
    UIScrollView *_filterGroupListView;
    FilterListView *_filterListView;
    NCFilterType _filterType;
    NSInteger _filterId;
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
        self.backgroundColor = colorWithHexString(@"#2f2f2f");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockGroup:) name:UNLOCK_BW object:nil];
        CGFloat scrollViewW = self.bounds.size.width;
        CGFloat scrollViewH = self.bounds.size.height;
        _filterGroupListView = [[ScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollViewW, scrollViewH)];
        _filterGroupListView.backgroundColor = colorWithHexString(@"#2f2f2f");
        [self addSubview:_filterGroupListView];
        
        CGFloat itemW = 75;
        CGFloat itemH = scrollViewH;
        NSArray *filterGroupNames = [FilterTypeHelper allGroupNames];
        for (int i=0; i<filterGroupNames.count; i++)
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
            if (arr && [arr count]>0)
            {
                NSString *strColor = [arr objectAtIndex:0];
                item.lineColor = colorWithHexString([NSString stringWithFormat:@"#%@",strColor]);
            }
            
            //解锁BW
            if ((i == 4 || i == 5) && ![[[NSUserDefaults standardUserDefaults] objectForKey:UDKEY_ShareUnLock] boolValue])
            {
                item.nameLabel.hidden = YES;
                item.lockImageView.hidden = NO;
            }
            else
            {
                item.nameLabel.hidden = NO;
                item.lockImageView.hidden = YES;
            }
        }
        
        _filterListView = [[FilterListView alloc] initWithFrame:CGRectMake(0, scrollViewH, scrollViewW, scrollViewH)];
        _filterListView.backgroundColor = colorWithHexString(@"#2f2f2f");
        [self addSubview:_filterListView];
        _filterListView.delegate = self;
    }
    return self;
}

- (void)unlockGroup:(NSNotification *)notification
{
    NSInteger tag = [notification.object integerValue];
    for (ImageEditFilterViewItem *item in _filterGroupListView.subviews)
    {
        if (item.tag == tag)
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
    
    //解锁BW
    if ([groupItem.itemName isEqualToString:@"BW"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:UDKEY_ShareUnLock] boolValue])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(imageEditFilterView:ChangeFilterId:)])
        {
            [_delegate imageEditFilterViewGroupName:groupItem.itemName];
            return;
        }
    }
    
    //解锁RETRO
    if ([groupItem.itemName isEqualToString:@"RETRO"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:UNLOCK_RETRO] boolValue])
    {
        NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=mirrorgrid"];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
        {
            [[UIApplication sharedApplication] openURL:instagramURL];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FOLLOW_US_URL]];
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UNLOCK_RETRO];
        [[NSNotificationCenter defaultCenter] postNotificationName:UNLOCK_BW object:[NSNumber numberWithInteger:4]];
        
        return;
    }
    
    NSArray *filterIDs = [FilterTypeHelper filtersInGroup:groupItem.itemName];
    _filterListView.filterIDs = filterIDs;
    [IS_Tools ViewAnimation:_filterListView withFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [IS_Tools ViewAnimation:_filterGroupListView withFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}

#pragma mark - FilterListViewViewDelegate
-(void)filterListView:(FilterListView *)filterListView SelectedFilterId:(NSInteger)filterId
{
    _filterId = filterId;
    if (_delegate && [_delegate respondsToSelector:@selector(imageEditFilterView:ChangeFilterId:)])
    {
        [_delegate imageEditFilterView:self ChangeFilterId:_filterId];
    }
}

- (void)filterListViewRequsetReturn:(FilterListView *)filterListView
{
    [IS_Tools ViewAnimation:_filterGroupListView withFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [IS_Tools ViewAnimation:_filterListView withFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}

-(void)secondTimeSelectListView
{
    if (_delegate && [_delegate respondsToSelector:@selector(secondTimeSelectListView)])
    {
        [_delegate secondTimeSelectListView];
    }
}

@end
