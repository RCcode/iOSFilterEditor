//
//  IS_RequestManager.h
//  iOSNoCropVideo
//
//  Created by TCH on 14-8-14.
//  Copyright (c) 2014年 com.rcplatformhk. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef void (^RequestSuccess)(id responseObject);
//typedef void (^RequestFailed)(NSError *error);

@interface IS_RequestManager : NSObject

+ (IS_RequestManager *)shareInstance;

- (BOOL)checkNetWorking;

-(void)getMoreAppSuccess:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)getAds:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)requestTypeFaceSuccess:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

- (void)updateVersionSuccess:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

- (void)registerToken:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)cancleAllRequests;

@end
