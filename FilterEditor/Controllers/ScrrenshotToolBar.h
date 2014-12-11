//
//  ScrrenshotToolBar.h
//  FilterGrid
//
//  Created by herui on 5/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+SubImage.h"

@class ScrrenshotToolBar;

@protocol ScrrenshotToolBarDelegate <NSObject>

@optional
- (void)scrrenshotToolBar:(ScrrenshotToolBar *)toolBar ItemOnClick:(AspectRatio)aspectRatio;
@end

@interface ScrrenshotToolBar : UIView

@property (nonatomic, weak) id<ScrrenshotToolBarDelegate> delegate;

@end
