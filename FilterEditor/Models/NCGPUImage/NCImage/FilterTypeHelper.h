//
//  FilterTypeHelper.h
//  FilterGrid
//
//  Created by herui on 28/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterTypeHelper : NSObject


/** 获取所有分组名 */
+ (NSArray *)allGroupNames;

/** 获取指定分组下的所有滤镜类型 */
+ (NSArray *)filtersInGroup:(NSString *)groupName;

/** 取指定滤镜类型默认的 specIntensity 值*/
//+ (CGFloat)defaultSpecIntensityForFilterType:(NCFilterType)filterType;

@end
