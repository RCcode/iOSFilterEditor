//
//  GetPath.m
//  RC_moreAPPsLib
//
//  Created by wsq-wlq on 14-11-27.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import "GetPath.h"

#define MYBUNDLE_NAME @ "RC_moreAPPsLibBundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@implementation GetPath



+ (NSString *)getMyBundlePath:(NSString *)filename
{
    
    NSBundle *myBundle = [GetPath getBundle];
    
    if (myBundle && filename) {
        
        return [[myBundle resourcePath] stringByAppendingPathComponent: filename];
    }
    
    return nil;
}

+ (NSBundle *)getBundle
{
    
    return [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource: MYBUNDLE_NAME ofType: @"bundle"]];
}

@end
