//
//  AppDelegate.m
//  FilterEditor
//
//  Created by gaoluyangrc on 14-12-3.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "PRJ_Global.h"
#import "RC_moreAPPsLib.h"
#import "Common.h"
#import "CMethods.h"
#import "PRJ_DataRequest.h"
#import "UIDevice+DeviceInfo.h"
#import "MobClick.h"


@interface AppDelegate ()
{
    UIViewController *_rootViewController;
    UIImageView *splashScreen;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    nav.navigationBar.translucent = NO;
    _rootViewController = nav;
    self.window.rootViewController = nav;
    
    [[RC_moreAPPsLib shareAdManager] requestWithMoreappId:20085];
    [self.window makeKeyAndVisible];
    [self loadFilterData];
    
    //注册通知
    [self registNotification];
    
    //展示闪屏
    [self showSplashScreen];
    
    //umeng
    [self umengSetting];
    
    //AFNetWorking
    [self netWorkingSetting];
    
    //版本更新
    [self checkVersion];
    
    return YES;
}

#pragma mark -
#pragma mark umeng
- (void)umengSetting
{
    [MobClick startWithAppkey:UmengAPPKey reportPolicy:SEND_ON_EXIT channelId:@"App Store"];
    [MobClick updateOnlineConfig];
}

#pragma mark -
#pragma mark 配置AFN
- (void)netWorkingSetting
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
}

#pragma mark -
#pragma mark 版本检测
- (void)checkVersion
{
    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",kAppID];
    PRJ_DataRequest *request = [[PRJ_DataRequest alloc] initWithDelegate:self];
    [request updateVersion:urlStr withTag:10];
}

#pragma mark 开机闪屏
-(void)showSplashScreen
{
    splashScreen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    splashScreen.userInteractionEnabled = YES;
    UIImageView *iconImage = [[UIImageView alloc]init];
    [iconImage setImage:[UIImage imageNamed:@"fe_Animation_logo_1136"]];
    iconImage.frame = CGRectMake((ScreenWidth-132)/2, 90, 132, 132);
    [splashScreen addSubview:iconImage];
    if(kScreen3_5)
    {
        splashScreen.image = [UIImage imageNamed:@"fe_Animation_bg_960"];
    }
    else if (kScreen4_0)
    {
        splashScreen.image = [UIImage imageNamed:@"fe_Animation_bg_1136"];
    }
    else if (kScreen4_7)
    {
        splashScreen.image = [UIImage imageNamed:@"fe_Animation_bg_1334"];
    }
    else
    {
        splashScreen.image = [UIImage imageNamed:@"fe_Animation_bg"];
    }
    [self.window addSubview:splashScreen];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0, 0, 1.0)];
    //执行时间
    animation.duration = 0.2;
    animation.cumulative = YES;//累积的
    //执行次数
    animation.repeatCount = 5;
    animation.autoreverses=NO;//是否自动重复
    animation.delegate = self;
    
    [iconImage.layer addAnimation:animation forKey:@"rotateAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    __weak UIView *splash = splashScreen;
    [UIView animateWithDuration:0.5 animations:^{
        splash.alpha = 0;
    } completion:^(BOOL finished) {
        [splash removeFromSuperview];
    }];
}

#pragma mark -滤镜数据加载
-(void)loadFilterData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FilterList" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [PRJ_Global shareStance].filterDictionary = data;
}

- (void)registNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

- (void)cancelNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSRange range = NSMakeRange(1,[[deviceToken description] length]-2);
    NSString *deviceTokenStr = [[deviceToken description] substringWithRange:range];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSLog(@"token.....%@",token);
    if (token == nil || [token isKindOfClass:[NSNull class]] || ![token isEqualToString:deviceTokenStr])
    {
        [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:@"deviceToken"];
        //注册token
        [self postData:[NSString stringWithFormat:@"%@",deviceTokenStr]];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error.....%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self doNotificationWithInfo:userInfo];
}

#pragma mark -
#pragma mark 处理远程通知事件
- (void)doNotificationWithInfo:(NSDictionary *)userInfo
{
    [self cancelNotification];
    if(userInfo == nil) return;
    NSDictionary *dictionary = [userInfo objectForKey:@"aps"];
    NSString *alert = [dictionary objectForKey:@"alert"];
    NSString *type = [userInfo objectForKey:@"type"];
    NSString *urlStr = [userInfo objectForKey:@"url"];
    
    switch (type.intValue)
    {
        case 0:
        {
            //Ad
            self.updateUrlStr = urlStr;
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@""
                                                               message:alert
                                                              delegate:self
                                                     cancelButtonTitle:LocalizedString(@"cancel", @"")
                                                     otherButtonTitles:LocalizedString(@"dialog_sure", @""), nil];
            alertView.tag = 12;
            [alertView show];
            
        }
            break;
        case 1:
        {
            //Update
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                           message:LocalizedString(@"New Version available", @"")
                                                          delegate:self
                                                 cancelButtonTitle:LocalizedString(@"Remind later", @"")
                                                 otherButtonTitles:LocalizedString(@"Upgrade now", @""), nil];
            alert.tag = 13;
            [alert show];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 11)
    {
        if(buttonIndex == 2){//稍后
            return;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:@(-1) forKey:UDKEY_ShareCount];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if(buttonIndex == 1)
        {//马上评
            NSString *nsStringToOpen = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",kAppID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
        }
    }
    else if (alertView.tag == 12)
    {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrlStr]];
        }
    }
    else if (alertView.tag == 13 || alertView.tag == 14)
    {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreURL]];
        }
    }
}

#pragma mark -
#pragma mark 获取设备信息
- (NSDictionary *)deviceInfomation:(NSString *)token
{
    @autoreleasepool
    {
        //Bundle Id
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *systemVersion = [UIDevice currentVersion];
        NSString *model = [UIDevice currentModel];
        NSString *modelVersion = [UIDevice currentModelVersion];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"Z"];
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        [dateFormatter setTimeZone:timeZone];
        NSDate *date = [NSDate date];
        //+0800
        NSString *timeZoneZ = [dateFormatter stringFromDate:date];
        NSRange range = NSMakeRange(0, 3);
        //+08
        NSString *timeZoneInt = [timeZoneZ substringWithRange:range];
        //en
        NSArray *languageArray = [NSLocale preferredLanguages];
        NSString *language = [languageArray objectAtIndex:0];
        //US
        NSLocale *locale = [NSLocale currentLocale];
        NSString *country = [[[locale localeIdentifier] componentsSeparatedByString:@"_"] lastObject];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:token forKeyPath:@"token"];
        [params setValue:timeZoneInt forKeyPath:@"timeZone"];
        [params setValue:language forKey:@"language"];
        [params setValue:bundleIdentifier forKeyPath:@"bundleid"];
        [params setValue:idfv forKeyPath:@"mac"];
        [params setValue:bundleIdentifier forKeyPath:@"pagename"];
        [params setValue:model forKeyPath:@"model"];
        [params setValue:modelVersion forKeyPath:@"model_ver"];
        [params setValue:systemVersion forKeyPath:@"sysver"];
        [params setValue:country forKeyPath:@"country"];
        
        return params;
    }
}

#pragma mark -
#pragma mark 提交设备信息
- (void)postData:(NSString *)token
{
    NSDictionary *infoDic = [self deviceInfomation:token];
    PRJ_DataRequest *request = [[PRJ_DataRequest alloc] initWithDelegate:self];
    [request registerToken:infoDic withTag:15];
}

#pragma mark -
#pragma mark WebDataRequestDelegate
- (void)didReceivedData:(NSDictionary *)dic withTag:(NSInteger)tag
{
    switch (tag)
    {
        case 10:
        {
            //解析数据
            NSArray *results = [dic objectForKey:@"results"];
            if ([results count] == 0 || results == nil || [results isKindOfClass:[NSNull class]])
            {
                return ;
            }
            NSDictionary *dictionary = [results objectAtIndex:0];
            NSString *version = [dictionary objectForKey:@"version"];
            NSString *trackViewUrl = [dictionary objectForKey:@"trackViewUrl"];//地址trackViewUrl
            self.trackURL = trackViewUrl;
            
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
            
            if ([currentVersion compare:version options:NSNumericSearch] == NSOrderedAscending)
            {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                               message:LocalizedString(@"application_update", @"")
                                                              delegate:self
                                                     cancelButtonTitle:LocalizedString(@"cancel", @"")
                                                     otherButtonTitles:LocalizedString(@"go", @""), nil];
                alert.tag = 14;
                [alert show];
                
            }
        }
            break;
        default:
            break;
    }
    
    hideMBProgressHUD();
}

- (void)requestFailed:(NSInteger)tag
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FilterEditor" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FilterEditor.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support
- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark -
#pragma mark 配置AFN
- (void)netWorkingSeting
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
}

@end
