//
//  ImageEditView.h
//  FilterGrid
//
//  Created by herui on 16/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCFilters.h"


@class ImageEditView;
@protocol ImageEditViewDelegate <NSObject>

@optional
-(void)imageEditView:(ImageEditView *)imageEditView ChangeFilterId:(NSInteger)filterId;
-(void)imageEditView:(ImageEditView *)imageEditView ChangeFilterIntensity:(CGFloat)intensity WithFilterId:(NSInteger)filterId;
- (void)imageEditView:(ImageEditView *)imageEditView AdjustImageWithAdjustImageParam:(AdjustImageParam)adjustImageParam;
- (void)imageEditViewConfirm:(ImageEditView *)imageEditView;
- (void)imageEditViewRecover:(BOOL)recover;
- (void)imageEditViewGropName:(NSString *)name;

@end


@interface ImageEditView : UIView

@property (nonatomic, weak) id<ImageEditViewDelegate> delegate;
@property (nonatomic, assign) float starValue;
@property (nonatomic, assign) float endValue;

-(void)hideFilterIntensitySliderView;
- (void)setEditAdjustViewParam:(AdjustImageParam)param;

@end
