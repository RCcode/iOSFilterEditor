//
//  EditViewController.h
//  FilterGrid
//
//  Created by herui on 4/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@class TemplatModel;
@class TemplateViewController;

typedef void (^CreatBaseImage)(UIImage *resultImage);

@interface EditViewController : UIViewController

@property (nonatomic, strong) UIImage *srcImage;
@property (nonatomic, strong) CreatBaseImage produceBaseImage;

/** 宽高比 */
@property (nonatomic, assign) AspectRatio aspectRatio;

- (void)creatBaseImage:(CreatBaseImage)baseImage;

@end
