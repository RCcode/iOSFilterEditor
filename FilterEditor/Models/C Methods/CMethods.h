//
//  CMethods.h
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-13.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Common.h"
#import "IS_LoadingView.h"

@interface CMethods : NSObject
{
    
}

//window 高度
CGFloat windowHeight();

CGFloat windowWidth();

//statusBar隐藏与否的高
CGFloat heightWithStatusBar();

//view 高度
CGFloat viewHeight(UIViewController *viewController);

//加载图片
UIImage* pngImagePath(NSString *name);
UIImage* jpgImagePath(NSString *name);
UIImage *loadImageWithName(NSString *imageName);

//数字转化为字符串
NSString* stringForInteger(int value);

//系统语言环境
NSString* currentLanguage();

BOOL iPhone5();
BOOL iPhone4();

BOOL IOS7_Or_Higher();

//返回随机不重复树
NSMutableArray* randrom(int count,int totalCount);

//十六进制颜色值
UIColor* colorWithHexString(NSString *stringToConvert);

//把字典转化为json串
NSData* toJSONData(id theData);

MBProgressHUD * showMBProgressHUD(NSString *content,BOOL showView);
void hideMBProgressHUD();

void showLabelHUD(NSString *content);

IS_LoadingView *showLoadingView(NSString *str);
void hideLoadingView();

//转换时间戳
NSString *exchangeTime(NSString *time);

//美工px尺寸，转ios字体size（接近值）
CGFloat fontSizeFromPX(CGFloat pxSize);

//当前应用的版本
NSString *appVersion();

//统一使用它做 应用本地化 操作
NSString *LocalizedString(NSString *translation_key, id none);


void cancleAllRequests();

//获取设备型号
NSString *doDevicePlatform();

//打印系统所有已注册的字体名称
void enumerateFonts();

//打印设备当前内存信息
void logMemoryInfo();

//获取某个目录下的所有图片名
NSArray* getImagesArray(NSString *folderName, NSString *type);

CGSize sizeWithContentAndFont(NSString *content,CGSize size,float fontSize);

//根据内容和字体获得标签大小
CGRect getTextLabelRectWithContentAndFont(NSString *content,UIFont *font);


/** 
 * 获取设备信息，包括：
 * app版本号 手机型号 手机系统版本 分辨率 语言
 */
NSString *getDeviceInfo();


/** 重置adjustParam */
void restoreAdjustImageParam(AdjustImageParam *param);

@end
