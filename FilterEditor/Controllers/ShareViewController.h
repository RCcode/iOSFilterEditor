//
//  ShareViewController.h
//  IOSNoCrop
//
//  Created by herui on 2/7/14.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Common.h"
@class EditViewController;

@interface ShareViewController : UIViewController <MFMailComposeViewControllerDelegate>

/** 宽高比 */
@property (nonatomic, assign) AspectRatio aspectRatio;
@property (nonatomic, strong) EditViewController *editCtr;

@end
