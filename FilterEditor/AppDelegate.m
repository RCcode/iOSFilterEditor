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
    
    //展示闪屏
    [self showSplashScreen];
    return YES;
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
