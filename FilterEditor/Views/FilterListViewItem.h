//
//  FilterListViewItem.h
//  FilterGrid
//
//  Created by herui on 28/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterListViewItem : UIButton

@property (nonatomic, assign) NSInteger filterId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) UIColor *lineColor;

@end
