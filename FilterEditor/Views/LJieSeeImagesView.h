//
//  LJieSeeImagesView.h
//  LJieSeeImages
//
//  Created by liangjie on 14/11/27.
//  Copyright (c) 2014年 liangjie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RandomNumber)(NSInteger number);

@interface LJieSeeImagesView : UIScrollView

@property (nonatomic ,strong) RandomNumber randomNumber;

- (void)scanImagesMode:(UIImage *)image;
- (void)receiveRandomNumber:(RandomNumber)numberValue;

@end
