//
//  EditViewController.h
//  FilterGrid
//
//  Created by herui on 4/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface EditViewController : UIViewController

@property (nonatomic, strong) UIImage *srcImage;

/** 宽高比 */
@property (nonatomic, assign) AspectRatio aspectRatio;

@end
