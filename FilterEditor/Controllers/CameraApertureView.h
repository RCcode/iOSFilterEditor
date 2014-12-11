//
//  CameraAperture.h
//  PRJ_Test
//
//  Created by 贺瑞 on 14-4-16.
//  Copyright (c) 2014年 rcplatfrom. All rights reserved.
//
//  系统名称：取景框
//  功能描述：用于高亮显示需要截取

#import "ControlBorder.h"
#import "Common.h"

@class CameraApertureView;
@interface CameraApertureView : UIView

//控制边框
@property (nonatomic,strong) ControlBorder *controlBorder;
@property (nonatomic,assign) AspectRatio style;
@property (nonatomic, weak) id<CameraApertureDelegate> delegate;

@end
