//
//  ImageEditAdjustViewBottomBar.h
//  FilterGrid
//
//  Created by herui on 16/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageEditAdjustViewBottomBar;

typedef enum{
    kImageAdjustItemTypeBrightness = 0,     //亮度
    kImageAdjustItemTypeContrast,           //对比度
    kImageAdjustItemTypeSaturation,         //饱和度
    kImageAdjustItemTypeTotalNumber,
    kImageAdjustItemTypeColorTemperature,   //色温
    kImageAdjustItemTypeSharpening         //锐化
    
//    kImageAdjustItemTypeTotalNumber
}ImageAdjustItemType;

@protocol ImageEditAdjustViewBottomBarDelegate <NSObject>

@optional
- (void)imageEditAdjustViewBottomBar:(ImageEditAdjustViewBottomBar *)imageEditAdjustViewBottomBar DidSelectTyep:(ImageAdjustItemType)type;
@end


@interface ImageEditAdjustViewBottomBar : UIView

@property (nonatomic, weak) id<ImageEditAdjustViewBottomBarDelegate> delegate;

@end
