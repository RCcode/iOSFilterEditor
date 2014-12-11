//
//  ImageEditTopBar.h
//  FilterGrid
//
//  Created by herui on 16/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageEditTopBar;

typedef enum{
    kImageEditTopBarItemTypeFilter = 0,
    kImageEditTopBarItemTypeAdjust,
    kImageEditTopBarItemTypeConfirm,
    
    kImageEditTopBarItemTypeConfirmTotalNumber,
}ImageEditTopBarItemType;

@protocol ImageEditTopBarDelegate <NSObject>

@optional
- (void)imageEditTopBar:(ImageEditTopBar *)imageEditTopBar DidSelectItemWithType:(ImageEditTopBarItemType)itemType;
@end

@interface ImageEditTopBar : UIView

@property (nonatomic, weak) id<ImageEditTopBarDelegate> delegate;

@end
