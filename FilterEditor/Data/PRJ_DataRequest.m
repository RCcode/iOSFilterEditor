//
//  PRJ_DataRequest.m
//  IOSNoCrop
//
//  Created by rcplatform on 14-4-18.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "PRJ_DataRequest.h"
#import "AppDelegate.h"
#import "CMethods.h"
#import "Reachability.h"

@implementation PRJ_DataRequest

- (id)initWithDelegate:(id<WebRequestDelegate,DownLoadTypeFaceDelegate>)request_Delegate
{
    self = [super init];
    
    self.delegate = request_Delegate;
    
    return self;
}

#pragma mark -
#pragma mark 公共请求 （Post）
- (void)requestServiceWithPost:(NSString *)url_Str jsonRequestSerializer:(AFJSONRequestSerializer *)requestSerializer isRegisterToken:(BOOL)token
{

    NSString *url = [NSString stringWithFormat:@"%@%@",HTTP_BASEURL ,url_Str];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.manager.requestSerializer = requestSerializer;
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    appDelegate.manager.responseSerializer = responseSerializer;
    
    [appDelegate.manager POST:token?kPushURL:url parameters:self.valuesDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析数据
        NSDictionary *dic = (NSDictionary *)responseObject;
        [self.delegate didReceivedData:dic withTag:requestTag];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hideMBProgressHUD();
        NSLog(@"error.......%@",error);
        [self.delegate requestFailed:requestTag];
    }];
}

#pragma mark -
#pragma mark 公共请求 （Get）
- (void)requestServiceWithGet:(NSString *)url_Str
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    appDelegate.manager.requestSerializer = requestSerializer;
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    appDelegate.manager.responseSerializer = responseSerializer;
    
    [appDelegate.manager GET:url_Str parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         //解析数据
                         NSDictionary *dic = (NSDictionary *)responseObject;
                         [self.delegate didReceivedData:dic withTag:requestTag];
    }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [self.delegate requestFailed:requestTag];
    }];
    
}

#pragma mark -
#pragma mark 检测网络状态
- (BOOL)checkNetWorking
{
    
    BOOL connected = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable ? YES : NO;
    
    if (!connected) {

    }
    
    return connected;
}

#pragma mark -
#pragma mark 请求图片贴纸图片
- (BOOL)requestPhotoMarksWithPostValues:(NSDictionary *)dictionary withTag:(NSInteger)tag
{
    if (![self checkNetWorking])
        return NO;
    requestTag = tag;
    self.valuesDictionary = dictionary;
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    [self requestServiceWithPost:@"getStickerInfos.do" jsonRequestSerializer:requestSerializer isRegisterToken:NO];
    
    return YES;
}

#pragma mark -
#pragma mark 请求字体贴纸数据
- (void)requestTypeFaceWithPostValues:(NSDictionary *)dictionary
{
    if (![self checkNetWorking]){
        showMBProgressHUD(LocalizedString(@"no_network_toast_string", nil), NO);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hideMBProgressHUD();
        });
        return;
    }
    
    showMBProgressHUD(nil, YES);
    self.valuesDictionary = dictionary;
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:15];
    [self requestServiceWithPost:@"getFonts.do" jsonRequestSerializer:requestSerializer isRegisterToken:NO];
}

#pragma mark -
#pragma mark 注册设备
- (void)registerToken:(NSDictionary *)dictionary withTag:(NSInteger)tag
{
    if (![self checkNetWorking])
        return;
    requestTag = tag;
    self.valuesDictionary = dictionary;
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    [self requestServiceWithPost:nil jsonRequestSerializer:requestSerializer  isRegisterToken:YES];
}

#pragma mark -
#pragma mark 版本更新
- (void)updateVersion:(NSString *)url withTag:(NSInteger)tag
{
    if (![self checkNetWorking])
        return;
    requestTag = tag;
    [self requestServiceWithGet:url];
}

- (NSTimer *)startRotateView:(UIView *)view{
    return [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(rotateView:) userInfo:view repeats:YES];
}

- (void)stopRotateView:(UIView *)view Timer:(NSTimer *)timer{
    [timer invalidate];
    view.transform = CGAffineTransformIdentity;
    UIImageView *imageView = (UIImageView *)view;
    imageView.image = pngImagePath(@"ic_box_delete@2x");
}

- (void)rotateView:(NSTimer *)timer{
    
    UIView *view = timer.userInfo;
    
    [UIView animateWithDuration:0.01 animations:^{
        
        if(timer.isValid){
            view.transform = CGAffineTransformRotate(view.transform, M_PI_4 * 0.1);
        }
    }];

}


@end
