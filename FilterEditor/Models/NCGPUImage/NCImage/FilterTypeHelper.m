//
//  FilterTypeHelper.m
//  FilterGrid
//
//  Created by herui on 28/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "FilterTypeHelper.h"
#import "NCFilters.h"
#import "PRJ_Global.h"

NSArray *groupNames;
NSArray *filterTypes;

@implementation FilterTypeHelper

+ (void)load
{
    groupNames = @[@"LOMO", @"FILM", @"PORTRAIT", @"COLOR", @"RETRO", @"BW"];

    filterTypes = @[@[@(IF_108), @(IF_109), @(IF_111), @(IF_112),@(IF_115), @(IF_120), @(IF_121), @(IF_123)],
                    @[@(IF_105), @(IF_107), @(IF_116), @(IF_117), @(IF_122), @(IF_143), @(IF_145), @(IF_146)],
                    @[@(IF_23), @(IF_26), @(IF_40), @(IF_50), @(IF_63), @(IF_83), @(IF_86), @(IF_92)],
                    @[@(IF_202), @(IF_242), @(IF_243), @(IF_251), @(IF_252), @(IF_253), @(IF_254), @(IF_255)],
                    @[@(IF_42),@(IF_99), @(IF_100), @(IF_101), @(IF_102), @(IF_103), @(IF_110),@(IF_114)],
                    @[@(IF_22), @(IF_78), @(IF_80), @(IF_94), @(IF_95), @(IF_96), @(IF_97), @(IF_98)]
                    ];
}

+ (NSArray *)allGroupNames
{
    return groupNames;
}

+ (NSArray *)filtersInGroup:(NSString *)groupName
{
    if([groupNames containsObject:groupName])
    {
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[[PRJ_Global shareStance].filterDictionary objectForKey:groupName]];
        if (array && [array count]>0)
        {
            [array removeObjectAtIndex:0];
        }
        return array;
    }
    return nil;
}

@end
