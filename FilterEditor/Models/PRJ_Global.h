//
//  PRJ_Global.h
//  IOSNoCrop
//
//  Created by rcplatform on 14-4-18.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Common.h"
@class GADInterstitial;

typedef void (^ChangeType)(NSInteger number);
typedef void (^SelectFilterID)(NSInteger filterIndex);
typedef void (^RandomNumber)(NSInteger number,BOOL isNeedFilter);

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
@property (nonatomic, strong) NSString *filterTitle;
//输出分辨率类型
@property (nonatomic, assign) OutputResolutionType outputResolutionType;
@property (nonatomic ,strong) NSMutableArray *filterTypeArrays;
@property (nonatomic ,strong) NSMutableArray *filter_image_array;
@property (nonatomic ,strong) ChangeType changeType;
@property (nonatomic ,strong) SelectFilterID selectedFilterID;
@property (nonatomic ,strong) RandomNumber randomNumber;
@property (nonatomic ,assign) BOOL isClicked;
@property (nonatomic ,strong) NSString *groupName;
@property (nonatomic ,assign) NSInteger groupType;
@property (nonatomic ,assign) NCFilterType last_random_filter_type;
@property (nonatomic ,assign) float strongValue;

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
- (void)receiveRandomNumber:(RandomNumber)numberValue;

@end
