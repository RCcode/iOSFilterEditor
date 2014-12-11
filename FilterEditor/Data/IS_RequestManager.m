//
//  IS_RequestManager.m
//  iOSNoCropVideo
//
//  Created by TCH on 14-8-14.
//  Copyright (c) 2014年 com.rcplatformhk. All rights reserved.
//

#import "IS_RequestManager.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "Common.h"

#define HTTP_FONTURL @"http://font.rcplatformhk.net/multiplatresweb/external/getFontsV1.do"
#define kMoreAppBaseURL @"http://moreapp.rcplatformhk.net/pbweb/app/getIOSAppListNew.do"

@interface IS_RequestManager ()

@property (nonatomic,strong) AFHTTPRequestOperationManager *operation;

@end

@implementation IS_RequestManager

static IS_RequestManager *requestManager = nil;

+ (IS_RequestManager *)shareInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        requestManager = [[IS_RequestManager alloc]init];
        requestManager.operation = [AFHTTPRequestOperationManager manager];
    });
    return requestManager;
}

#pragma mark -
#pragma mark 公共请求 （Get）

-(void)requestServiceWithGet:(NSString *)url_Str success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    _operation.requestSerializer = requestSerializer;
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    _operation.responseSerializer = responseSerializer;
    
    [_operation GET:url_Str parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         //解析数据
                         if (success) {
                             success(responseObject);
                         }
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         if (failure) {
                             failure(error);
                         }
                     }];

}

#pragma mark -
#pragma mark 公共请求 （Post）

- (void)requestServiceWithPost:(NSString *)url_Str parameters:(id)parameters jsonRequestSerializer:(AFJSONRequestSerializer *)requestSerializer success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    _operation.responseSerializer = responseSerializer;
    
    [_operation POST:url_Str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析数据
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

#pragma mark -
#pragma mark 广告
-(void)getAds:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    NSDictionary *dic = @{@"app_id":[NSNumber numberWithInt:kMoreAppID]};
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    _operation.requestSerializer = requestSerializer;
    
    [self requestServiceWithPost:AdUrl parameters:dic jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -
#pragma mark MoreApp

-(void)getMoreAppSuccess:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
    NSString *language = [[NSLocale preferredLanguages] firstObject];
    if ([language isEqualToString:@"zh-Hans"])
    {
        language = @"zh";
    }
    else if ([language isEqualToString:@"zh-Hant"])
    {
        language = @"zh_TW";
    }
    NSDictionary *dic = @{@"appId":[NSNumber numberWithInt:kMoreAppID],@"packageName":bundleIdentifier,@"language":language,@"version":currentVersion,@"platform":[NSNumber numberWithInt:0]};
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestSerializer setTimeoutInterval:30];
    _operation.requestSerializer = requestSerializer;
    
//    NSString *url = [NSString stringWithFormat:@"%@%@", kMoreAppBaseURL ,@"getIOSAppList.do"];
    NSString *url = kMoreAppBaseURL;
    
    [self requestServiceWithPost:url parameters:dic jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -
#pragma mark 请求字体贴纸数据

-(void)requestTypeFaceSuccess:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
//    NSArray *languageArray = [NSLocale preferredLanguages];
//    NSString *language = [languageArray objectAtIndex:0];
//    
//    if ([language isEqualToString:@"zh-Hant"]) {
//        language = @"zh_TW";
//    }
//    NSDictionary *dic = @{@"ver": @"1",@"lang": language,@"plat": @"20",@"aid": @"100021",@"state": @"1"};
    
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *language = [languageArray objectAtIndex:0];
    NSInteger defEn = 0;
    
    if ([language isEqualToString:@"zh-Hant"]) {
        language = @"zh_TW";
        defEn = 1;
    }
    else if ([language isEqualToString:@"zh-Hans"])
    {
        language = @"zh";
        defEn = 1;
    }
    else if ([language isEqualToString:@"ja"])
    {
        language = @"ja";
        defEn = 1;
    }
    else if ([language isEqualToString:@"ko"])
    {
        language = @"ko";
        defEn = 1;
    }
    else if ([language isEqualToString:@"ru"])
    {
        language = @"ru";
        defEn = 1;
    }
    else if ([language isEqualToString:@"th"])
    {
        language = @"th";
        defEn = 0;
    }
    else if ([language isEqualToString:@"ar"])
    {
        language = @"ar";
        defEn = 0;
    }
    else
    {
        language = @"en";
    }
    NSDictionary *dic = @{@"version": @100,@"lang":language,@"platType": @2,@"appId": @0,@"state": @1,@"modelType":@0,@"defEn":[NSNumber numberWithInteger:defEn]};
//    NSDictionary *dic = @{@"version": @"1.0.0",@"lang":language,@"platType": @2,@"appId": @kMoreAppID,@"state": @1,@"modelType":@0,@"defEn":[NSNumber numberWithInteger:defEn]};
//    NSDictionary *dic = @{@"version": @100,@"lang":language,@"platType": @2,@"appId": @0,@"state": @1,@"modelType":@0,@"defEn":[NSNumber numberWithInteger:defEn]};
//    NSDictionary *dic1 = @{@"ver": @"1",@"lang": language,@"plat": @"20",@"aid": @"100021",@"state": @"1"};
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestSerializer setTimeoutInterval:15];
    _operation.requestSerializer = requestSerializer;

//    [NSString stringWithFormat:@"%@getFonts.do",HTTP_BASEURL ]
    [self requestServiceWithPost:HTTP_FONTURL parameters:dic jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -
#pragma mark 版本更新

- (void)updateVersionSuccess:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",kAppID];
    [self requestServiceWithGet:urlStr success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -
#pragma mark 注册设备

- (void)registerToken:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    [self requestServiceWithPost:kPushURL parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -
#pragma mark 检测网络状态
- (BOOL)checkNetWorking
{
    BOOL connected = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable ? YES : NO;
    
    return connected;
}

-(void)cancleAllRequests
{
    [_operation.operationQueue cancelAllOperations];
}

@end
