//
//  FilterListView.h
//  FilterGrid
//
//  Created by herui on 28/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilterListView;

@protocol FilterListViewViewDelegate <NSObject>

@optional
- (void)filterListView:(FilterListView *)filterListView SelectedFilterId:(NSInteger)filterId itemTag:(NSInteger)tag;
- (void)filterListViewRequsetReturn:(FilterListView *)filterListView;
- (void)secondTimeSelectListView;
@end

@interface FilterListView : UIView

@property (nonatomic, weak) id<FilterListViewViewDelegate> delegate;
@property (nonatomic, strong) NSArray *filterIDs;

@end
