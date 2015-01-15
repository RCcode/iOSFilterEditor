//
//  PRJ_Global.h
//  IOSNoCrop
//
//  Created by rcplatform on 14-4-18.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class GADInterstitial;

typedef void (^ChangeType)(NSInteger number);
typedef void (^SelectFilterID)(NSInteger filterIndex);

//输出分辨率类型
typedef enum
{
    kOutputResolutionType3240_3240 = 0,
    kOutputResolutionType1080_1080 = 1,

    kOutputResolutionTypeTotalNumber
}OutputResolutionType;

@interface PRJ_Global : NSObject

@property (nonatomic ,strong) UIImage *originalImage; //原始图片
@property (nonatomic ,strong) UIImage *compressionImage; //压缩后的图片
@property (nonatomic, assign) float freeScale;
@property (nonatomic, assign) BOOL showBackMsg;
@property (nonatomic, assign) float maxScaleValue;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) NSInteger draggingIndex;
@property (nonatomic, strong) NSMutableDictionary *filterDictionary;
//输出分辨率类型
@property (nonatomic, assign) OutputResolutionType outputResolutionType;

@property (nonatomic ,strong) ChangeType changeType;
@property (nonatomic ,strong) SelectFilterID selectedFilterID;

+ (PRJ_Global *)shareStance;

/**
 *  全局公用统计分析方法
 */
+ (void)event:(NSString *)event label:(NSString *)label;

/**
 *  获取当前输出分辨率对应的字符串
 */
- (NSString *)getCurrentOutputResolutionStr;

/**
 *  获取指定输出分辨率对应的字符串
 */
- (NSString *)getOutputResolutionStrWithType:(OutputResolutionType)type;

- (void)changeFilterGroup:(ChangeType)changeGroupType;
- (void)selectedFilterID:(SelectFilterID)selectedID;

@end
