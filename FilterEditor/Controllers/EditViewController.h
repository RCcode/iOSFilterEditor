//
//  EditViewController.h
//  FilterGrid
//
//  Created by herui on 4/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

typedef void (^CreatBaseImage)(UIImage *resultImage);
typedef void (^ResiveFilerResult)(UIImage *filterImage);

@interface EditViewController : UIViewController

@property (nonatomic, strong) UIImage *srcImage;
@property (nonatomic ,strong) CreatBaseImage produceBaseImage;
@property (nonatomic ,strong) ResiveFilerResult filterResultImage;

/** 宽高比 */
@property (nonatomic, assign) AspectRatio aspectRatio;

- (void)creatBaseImage:(CreatBaseImage)baseImage;
+ (void)receiveFilterResult:(ResiveFilerResult)resultImage;

@end
