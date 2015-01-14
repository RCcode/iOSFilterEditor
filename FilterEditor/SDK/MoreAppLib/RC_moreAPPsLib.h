//
//  RC_moreAPPsLib.h
//  RC_moreAPPsLib
//
//  Created by wsq-wlq on 14-11-25.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKitDefines.h>
#import <UIKit/UIKit.h>

//UIKIT_EXTERN NSString *const KEYTOCELLTITLEFONT;
//UIKIT_EXTERN NSString *const KEYTOCELLTITLETEXTCOLOR;
//UIKIT_EXTERN NSString *const KEYTOCELLDETAILTITLEFONT;
//UIKIT_EXTERN NSString *const KEYTOCELLDETAILTITLTEXTCOLOR;
//UIKIT_EXTERN NSString *const KEYTOCELLCOMMENTTITLEFONT;
//UIKIT_EXTERN NSString *const KEYTOCELLCOMMENTTITLETEXTCOLOR;

@interface RC_moreAPPsLib : NSObject


+ (id)shareAdManager;

- (void)setPopViewController:(UIViewController *)popViewController;

- (void)requestWithMoreappId:(NSInteger)appid;//请求moreAPP数据及广告弹出次数

- (void)showCustomAdsWithViewController:(UIViewController *)popController;//弹出moreApp方法

- (UIViewController *)getMoreAppController;//获取moreApp列表controller
- (UIView *)getShareView;//获取share页广告展示

- (void)setAdmobKey:(NSString *)admobKey;//admob广告key
- (void)showAdmobAdsWithController:(UIViewController *)presentController;//admob广告弹出方法

- (void)setTitleColor:(UIColor *)color;//设置弹出广告标题颜色
- (void)setBackGroundColor:(UIColor *)color;//设置弹出广告背景颜色

- (void)setShareTitleColor:(UIColor *)color;//设置Share标题颜色
- (void)setShareBackGroundColor:(UIColor *)color;//设置Share背景颜色

- (void)setMoreAppCellAttribut:(NSDictionary *)attribute;//设置cell样式

- (BOOL)isHaveNewApp;

@end

