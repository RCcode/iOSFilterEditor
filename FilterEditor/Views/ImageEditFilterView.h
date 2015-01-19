//
//  ImageEditFilterView.h
//  FilterGrid
//
//  Created by herui on 16/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCFilters.h"

@class ImageEditFilterView;

@protocol ImageEditFilterViewDelegate <NSObject>

@optional
- (void)imageEditFilterView:(ImageEditFilterView *)imageEditFilterView ChangeFilterId:(NSInteger)filterId btnTag:(NSInteger)buttonTag;
- (void)imageEditFilterViewGroupName:(NSString *)name;
- (void)secondTimeSelectListView;
@end

@interface ImageEditFilterView : UIView

@property (nonatomic, weak) id<ImageEditFilterViewDelegate> delegate;

@end
