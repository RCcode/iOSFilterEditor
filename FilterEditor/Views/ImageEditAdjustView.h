//
//  ImageEditAdjustView.h
//  FilterGrid
//
//  Created by herui on 16/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@class ImageEditAdjustView;

@protocol ImageEditAdjustViewDelegate <NSObject>

@optional
- (void)imageEditAdjustView:(ImageEditAdjustView *)imageEditAdjustView WithAdjustImageParam:(AdjustImageParam)adjustImageParam;
@end

@interface ImageEditAdjustView : UIView

@property (nonatomic, strong) UIView *slidersBgView;

@property (nonatomic, weak) id<ImageEditAdjustViewDelegate> delegate;

@property (nonatomic, assign) AdjustImageParam adjustImageParam;

@end
