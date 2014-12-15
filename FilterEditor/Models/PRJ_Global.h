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

//输出分辨率类型
typedef enum{
    kOutputResolutionType1080_1080 = 0,
    kOutputResolutionType1660_1660,
    kOutputResolutionType2160_2160,

    kOutputResolutionTypeTotalNumber
}OutputResolutionType;

@interface PRJ_Global : NSObject

@property (nonatomic ,strong) UIImage *originalImage; //原始图片
@property (nonatomic ,strong) UIImage *compressionImage; //压缩后的图片
@property (nonatomic ,strong) UIImage *photoMarkImage; //图片标签原图

@property (nonatomic ,strong) NSArray *photoMarksArray;

//用户最终编辑完成的图片（用于分享、本地保存）
@property (nonatomic, strong) UIImage *theBestImage;
@property (nonatomic, strong) UIImage *imageWithLogo;
@property (nonatomic, strong) UIImage *imageWithoutLogo;

//广告条
@property (nonatomic, strong) UIView *bannerView;

@property (nonatomic, assign) BOOL isCreate;

@property (nonatomic, strong) NSMutableArray *appsArray;
@property (nonatomic, assign) float freeScale;

@property (nonatomic, copy) NSString *templateName;

@property (nonatomic, assign) BOOL showBackMsg;

//当前模板中小块个数
@property (nonatomic, assign) int boxCount;
//压缩比例 根据小块个数定
@property (nonatomic, assign) float compScale;

@property (nonatomic, strong) NSMutableDictionary *filterDictionary;
@property (nonatomic, assign) BOOL canShowPopUp;

//输出分辨率类型
@property (nonatomic, assign) OutputResolutionType outputResolutionType;

/** 全屏广告 用户关闭之后，须重新创建 */
@property (nonatomic, strong) GADInterstitial *interstitial;

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



@end
