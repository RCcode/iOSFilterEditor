//
//  CMethods.m
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-13.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import "CMethods.h"
#import <stdlib.h>
#import <time.h>
#import "AppDelegate.h"
#import "sys/sysctl.h"
#include <mach/mach.h>

#define coverViewTag 122

@implementation CMethods

static UIView *coverView = nil;
void showCoverViewForWindow()
{
    if(!coverView)
    {
        coverView = [[UIView alloc] initWithFrame:currentWindow().bounds];
        coverView.tag = coverViewTag;
        coverView.backgroundColor = [UIColor clearColor];
        [currentWindow() addSubview:coverView];
    }
    else
    {
        coverView.hidden = NO;
    }
}

void hiddenCoverViewForWindow()
{
    coverView.hidden = YES;
}

UIWindow* currentWindow()
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    return window;
}

//window 高度
CGFloat windowHeight()
{
    return [UIScreen mainScreen].bounds.size.height;
}

CGFloat windowWidth()
{
    return [UIScreen mainScreen].bounds.size.width;
}

//statusBar隐藏与否的高
CGFloat heightWithStatusBar(){
    return NO==[UIApplication sharedApplication].statusBarHidden ? windowHeight()-20 :windowHeight();
}

//view 高度
CGFloat viewHeight(UIViewController *viewController){
    if (nil==viewController) {
        return heightWithStatusBar();
    }
    return YES==viewController.navigationController.navigationBarHidden ? heightWithStatusBar():heightWithStatusBar()-44;
    
}

UIImage* pngImagePath(NSString *name)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

UIImage* jpgImagePath(NSString *name)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

UIImage *loadImageWithName(NSString *imageName){
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
    return [UIImage imageWithContentsOfFile:path];
}

NSString* stringForInteger(int value)
{
    NSString *str = [NSString stringWithFormat:@"%d",value];
    return str;
}


//當前语言环境
NSString* currentLanguage()
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString *languangeType;
    NSString* preferredLang = [languages objectAtIndex:0];
    if ([preferredLang isEqualToString:@"zh-Hant"]){
        languangeType=@"ft";
    }else{
        languangeType=@"jt";
    }
    NSLog(@"Preferred Language:%@", preferredLang);
    return languangeType;
}

BOOL iPhone5(){
    if (568==windowHeight()) {
        return YES;
    }
    return NO;
}

BOOL iPhone4(){
    return (480 == windowHeight());
}

BOOL IOS7_Or_Higher(){
    return [[UIDevice currentDevice].systemVersion floatValue] >= 7.0 ? YES : NO;
}

//数学意义上的随机数在计算机上已被证明不可能实现。通常的随机数是使用随机数发生器在一个有限大的线性空间里取一个数。“随机”甚至不能保证数字的出现是无规律的。使用系统时间作为随机数发生器是常见的选择
NSMutableArray* randrom(int count,int totalCount){
    int x;
    int i;
    NSMutableArray *array=[[NSMutableArray alloc]init];
    time_t t;
    srand((unsigned) time(&t));
    for(i=0; i<count; i++){
        x=rand() % totalCount;
        printf("%d ", x);
        [array addObject:[NSString stringWithFormat:@"%d",x]];
    }
    printf("\n");
    return array;
}

UIColor* colorWithHexString(NSString *stringToConvert)
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor whiteColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

NSData* toJSONData(id theData)
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] != 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

MBProgressHUD *mb;
MBProgressHUD * showMBProgressHUD(NSString *content,BOOL showView)
{
    if(mb){
        hideMBProgressHUD();
    }
    
    //显示LoadView
    if (mb==nil) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        mb = [[MBProgressHUD alloc] initWithView:window];
        mb.mode = showView?MBProgressHUDModeIndeterminate:MBProgressHUDModeText;
        mb.userInteractionEnabled = NO;
        [window addSubview:mb];
        //如果设置此属性则当前的view置于后台
        //mb.dimBackground = YES;
        mb.labelText = content;
    }else{
        
        mb.mode = showView?MBProgressHUDModeIndeterminate:MBProgressHUDModeText;
        mb.labelText = content;
    }

    [mb show:YES];
    return mb;
}

void hideMBProgressHUD()
{
    [mb hide:YES];
    [mb removeFromSuperview];
    mb = nil;
}

MBProgressHUD *HUD;
UILabel *label;
void showLabelHUD(NSString *content)
{
    if (label == nil) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        label.font = [UIFont systemFontOfSize:28];
        label.textColor = colorWithHexString(@"#ffffff");
        label.shadowColor = colorWithHexString(@"#000000");
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
    }
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    label.center = window.center;
    [window addSubview:label];
    label.text = content;
    label.alpha = 1;
    [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionTransitionNone animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        if(label.alpha != 0)
        {
            [label removeFromSuperview];
        }
    }];
}

IS_LoadingView *loadingView;
IS_LoadingView *showLoadingView(NSString *str)
{
    if(loadingView){
        hideLoadingView();
    }
    if (loadingView==nil) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        loadingView = [[IS_LoadingView alloc] initWithFrame:window.bounds];
        [window addSubview:loadingView];
        [loadingView setProcess:0];
    }
    [loadingView setLaberString:str];
    [loadingView startAnimating];
    return loadingView;
}

void hideLoadingView()
{
    [loadingView stopAnimating];
}

NSString *exchangeTime(NSString *time)
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSInteger timeValues = [time integerValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeValues];
    NSString *dataStr = [formatter stringFromDate:confromTimesp];
    return dataStr;
}

CGFloat fontSizeFromPX(CGFloat pxSize){
    return (pxSize / 96.0) * 72 * 0.65;
}

NSString *appVersion(){
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

NSString *LocalizedString(NSString *translation_key, id none){

    NSString *language = @"en";
    
    //只适配这么些种语言，其余一律用en
    if([CURR_LANG isEqualToString:@"zh-Hans"] ||
       [CURR_LANG isEqualToString:@"zh-Hant"] ||
       [CURR_LANG isEqualToString:@"de"] ||
       [CURR_LANG isEqualToString:@"es"] ||
       [CURR_LANG isEqualToString:@"fr"] ||
       [CURR_LANG isEqualToString:@"it"] ||
       [CURR_LANG isEqualToString:@"ko"] ||
       [CURR_LANG isEqualToString:@"ja"] ||
       [CURR_LANG isEqualToString:@"pt"] ||
       [CURR_LANG isEqualToString:@"pt-PT"] ||
       [CURR_LANG isEqualToString:@"id"] ||
       [CURR_LANG isEqualToString:@"th"] ||
       [CURR_LANG isEqualToString:@"ar"] ||
       [CURR_LANG isEqualToString:@"ru"] ){
        language = CURR_LANG;
    }
    NSString * path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    NSBundle * languageBundle = [NSBundle bundleWithPath:path];
    NSString *str = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    return str ?: translation_key;
}

void cancleAllRequests()
{
    hideMBProgressHUD();
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.manager.operationQueue cancelAllOperations];
}


NSString *doDevicePlatform()
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    NSDictionary *devModeMappingMap = @{
        @"x86_64"    :@"Simulator",
        @"iPod1,1"   :@"iPod Touch",      // (Original)
        @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
        @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
        @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
        @"iPod5,1"   :@"iPod Touch",
        @"iPhone1,1" :@"iPhone",          // (Original)
        @"iPhone1,2" :@"iPhone",          // (3G)
        @"iPhone2,1" :@"iPhone",          // (3GS)
        @"iPhone3,1" :@"iPhone 4",        //
        @"iPhone4,1" :@"iPhone 4S",       //
        @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
        @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
        @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
        @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
        @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
        @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
        @"iPad1,1"   :@"iPad",            // (Original)
        @"iPad2,1"   :@"iPad 2",          //
        @"iPad2,2"   :@"iPad 2",
        @"iPad2,3"   :@"iPad 2",
        @"iPad2,4"   :@"iPad 2",
        @"iPad2,5"   :@"iPad Mini",       // (Original)
        @"iPad2,6"   :@"iPad Mini",
        @"iPad2,7"   :@"iPad Mini",
        @"iPad3,1"   :@"iPad 3",          // (3rd Generation)
        @"iPad3,2"   :@"iPad 3",
        @"iPad3,3"   :@"iPad 3",
        @"iPad3,4"   :@"iPad 4",          // (4th Generation)
        @"iPad3,5"   :@"iPad 4",
        @"iPad3,6"   :@"iPad 4",
        @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
        @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
        @"iPad4,4"   :@"iPad Mini 2",     // (2nd Generation iPad Mini - Wifi)
        @"iPad4,5"   :@"iPad Mini 2"      // (2nd Generation iPad Mini - Cellular)
    };

    NSString *devModel = [devModeMappingMap valueForKeyPath:platform];
    return (devModel) ? devModel : platform;
}


#pragma mark - 打印系统所有已注册的字体名称
void enumerateFonts() {
    for(NSString *familyName in [UIFont familyNames]){
        NSLog(@"%@",familyName);
        
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        
        for(NSString *fontName in fontNames){
            NSLog(@"\t|- %@",fontName);
        }
    }
}


BOOL memoryInfo(vm_statistics_data_t *vmStats) {
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)vmStats, &infoCount);
    return kernReturn == KERN_SUCCESS;
}

void logMemoryInfo() {
    
    vm_statistics_data_t vmStats;
    
    if (memoryInfo(&vmStats)) {
        
        NSLog(@"剩余内存:%ldM \t不活跃%ldM \t已使用:%ldM \t系统占用:%ldM",
              (long)(vmStats.free_count * vm_page_size / 1024 / 1024),
              (long)(vmStats.inactive_count * vm_page_size / 1024 / 1024),
              (long)(vmStats.active_count * vm_page_size / 1024 / 1024),
              (long)(vmStats.wire_count * vm_page_size / 1024 / 1024));

    }
}



#pragma mark 获取某个目录下的所有图片名
NSArray* getImagesArray(NSString *folderName, NSString *type)
{
    NSArray *returnArray = [[NSBundle mainBundle]pathsForResourcesOfType:type inDirectory:folderName];
    return returnArray;
}

CGSize sizeWithContentAndFont(NSString *content,CGSize size,float fontSize)
{
    
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    CGSize labelsize =[content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    return labelsize;
}

CGRect getTextLabelRectWithContentAndFont(NSString *content ,UIFont *font)
{
    CGSize size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    CGRect returnRect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil];
    
    return returnRect;
}


NSString *getDeviceInfo(){
    
    // app名称 版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //设备型号 系统版本
    NSString *deviceName = doDevicePlatform();
    NSString *deviceSystemName = [[UIDevice currentDevice] systemName];
    NSString *deviceSystemVer = [[UIDevice currentDevice] systemVersion];
    
    //设备分辨率
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat resolutionW = [UIScreen mainScreen].bounds.size.width * scale;
    CGFloat resolutionH = [UIScreen mainScreen].bounds.size.height * scale;
    NSString *resolution = [NSString stringWithFormat:@"%.f*%.f", resolutionW, resolutionH];
    
    //本地语言
    NSString *language = [[NSLocale preferredLanguages] firstObject];
    
    //            NSString *diveceInfo = @"app版本号 手机型号 手机系统版本 分辨率 语言";
    return [NSString stringWithFormat:@"%@ %@, %@, %@ %@, %@, %@", app_Name, app_Version, deviceName, deviceSystemName, deviceSystemVer,  resolution, language];
}

void restoreAdjustImageParam(AdjustImageParam *param){
    param->brightness = 0;
    param->contrast = 1;
    param->saturation = 1;
    param->colorTemperature = 1;
    param->sharpening = 0;
}

@end
