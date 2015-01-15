//
//  RC_ShowImageView.h
//  FilterEditor
//
//  Created by gaoluyangrc on 15-1-14.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RandomNumber)(NSInteger number,BOOL isNeedFilter);

@interface RC_ShowImageView : UIImageView

@property (nonatomic ,strong) RandomNumber randomNumber;

- (void)receiveRandomNumber:(RandomNumber)numberValue;

@end
