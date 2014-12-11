//
//  PRJ_Button.h
//  IOSNoCrop
//
//  Created by rcplatform on 14-4-19.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//
#import "GPUImageView.h"
#import "NCFilters.h"
#import "NCVideoCamera.h"

@interface ME_Button : UIButton <IFVideoCameraDelegate>

@property (nonatomic ,strong) UIImageView *toolImageView;
@property (nonatomic ,strong) NSString *normelName;
@property (nonatomic ,strong) NSString *selectName;
@property (nonatomic ,assign) NSInteger btnType;
@property (nonatomic ,strong) UILabel *contentLabel;
@property (nonatomic ,assign) NSInteger record;
@property (nonatomic ,assign) BOOL isTurn;

- (void)changeBtnImage;
- (void)btnHaveClicked;
@end
