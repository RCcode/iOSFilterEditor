//
//  Common.h
//  FilterGrid
//
//  Created by herui on 4/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#ifndef FilterGrid_Common_h
#define FilterGrid_Common_h

//Kakao AppID\URL Schemes 见info.plist
#define kWXAppID @"wxd930ea5d5a258f4f"
#define kPPURL @"http://192.168.0.86:8076/AdlayoutBossWeb/platform/getRcAdvConrol.do"
#define MY_INTERSTITIAL_UNIT_ID @"ca-app-pub-6180558811783876/7313852942"

#pragma mark -

#define kMoreAppID 20077//
#define UmengAPPKey @"5406cfa4fd98c51a1c001d3b"
#define FlurryAppKey @"93RV33S89KDGH49H4GCG"

#define kAppID @"919861751"
#define kNoCropAppID @"878086629"
#define kAppStoreURLPre @"itms-apps://itunes.apple.com/app/id"
#define kAppStoreURL [NSString stringWithFormat:@"%@%@", kAppStoreURLPre, kAppID]
#define kNoCropAppStoreURL [NSString stringWithFormat:@"%@%@", kAppStoreURLPre, kNoCropAppID]
#define kAppStoreScoreURLPre @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id="
#define kAppStoreScoreURL [NSString stringWithFormat:@"%@%@", kAppStoreScoreURLPre, kAppID]

#define HTTP_BASEURL @"http://iosnocrop.rcplatformhk.net/IOSNoCropWeb/external/"
#define kPushURL @"http://iospush.rcplatformhk.net/IOSPushWeb/userinfo/regiUserInfo.do"

#define AdMobID @"ca-app-pub-3747943735238482/5328990653"
#define AdUrl @"http://ads.rcplatformhk.com/AdlayoutBossWeb/platform/getRcAppAdmob.do"

#define kFeedbackEmail @"rcplatform.help@gmail.com"

#define kShareHotTags @"Made with @filtergrid #FilterGrid"
#define kFollwUsAccount @"filtergrid"
#define kFollwUsURL @"http://www.instagram.com/filtergrid"

//通知key
static NSString *NNKEY_SCREENSHOT = @"screenshot notiKey";
static NSString *DICTKEY_SUBIMAGE = @"subImage dictKey";
static NSString *SELECT_PHOTOMARK = @"selectPhotoMark";
static NSString *TOUCH_PHOTOMARK = @"touchPhotoMark";
static NSString *IMAGE_CHANGED = @"changeImage";
static NSString *NNKEY_GETTHEBESTIMAGE = @"get the best image";
static NSString *NNKEY_SHOWPHOTOVC = @"show photo view controller";
static NSString *NNKEY_SHOWROOTVC = @"show root view controller";
static NSString *CLEAR_COLORVIEW = @"clearView";
static NSString *UDKEY_WATERMARKSWITCH = @"water mark switch";
static NSString *DEVICE_TOKEN = @"deviceToken";
static NSString *DELETE_MARK = @"delete_Mark";
static NSString *HAVEDOWNLOAD = @"HaveDownLoad";
static NSString *NNKEY_FILTER_FINISH = @"filterVC finish";
static NSString *DICTKEY_FILTER_IMAGE = @"filterVC finish image dictKey";
static NSString *UDKEY_ShareCount = @"shareCount";


static NSString *UDKEY_OutputResolutionType = @"OutputResolutionType";

//评论&分享解锁开关
static NSString *UDKEY_ReviewUnLock = @"reviewUnLock";
static NSString *UDKEY_ShareUnLock = @"shareUnLock";
static NSString *UNLOCK_RETRO = @"unlock_RETRO";
static NSString *UNLOCK_BW = @"unlock_BW";

static NSString *kDefaultTemplateFileName = @"tp_grid_1";

#define FOLLOW_US_URL @"http://instagram.com/mirrorgrid"

//NSLog开关
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif


#define isFirstLaunch @"isFirstLaunch"
#define showCount @"showCount"


//随机颜色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1]

//屏幕size
#define kWinSize [UIScreen mainScreen].bounds.size
#define kScreen3_5 (kWinSize.height < 568)
#define kScreen4_0 (kWinSize.height == 568)
#define kScreen4_7 (kWinSize.height == 667)
#define kScreen5_5 (kWinSize.height == 736)

#define kNavBarH 44
//#define KTabBarH 49
#define kScreemWidth kWinSize.width
#define kScreemHeight kWinSize.height
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#define kOutputViewWH 1080

//导航栏标题文本属性
#define kNavTitleSize 18
#define kNavTitleFontName @"Prosto"

#define RGBA(int) [UIColor colorWithRed:((color >> 24) & 0xFF) / 255.0f \
                                  green:((color >> 16) & 0xFF) / 255.0f \
                                   blue:((color >> 8) & 0xFF) / 255.0f \
                                  alpha:((color) & 0xFF) / 255.0f];


#define ImageWrite2SandBox(image, fileName) [UIImageJPEGRepresentation(image, 0.8) writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName] atomically:YES]


//用户当前的语言环境
#define CURR_LANG   ([[NSLocale preferredLanguages] objectAtIndex:0])

//宽高比
typedef enum{
    kAspectRatioFree = 0,
    kAspectRatio1_1,
    kAspectRatio2_3,
    kAspectRatio3_4,
    kAspectRatio9_16,
    kAspectRatio3_2,
    kAspectRatio4_3,
    kAspectRatio16_9,
    
    kAspectRatioTotalNumber
}AspectRatio;

//模板类型
typedef enum{
    kTemplateTypeGrid = 1,
    kTemplateTypeShape,
    
    kTemplateTypeTotalNumber
}TemplateType;

//调整图片参数
typedef struct{
    CGFloat brightness;        //亮度      -1 ~ 1     0
    CGFloat contrast;          //对比度   0.5 ~ 1.5    1
    CGFloat saturation;        //饱和度     0 ~ 2      1
    CGFloat colorTemperature;  //色温     0.5 ~ 2     1
    CGFloat sharpening;        //锐化       0 ~ 2     0
}AdjustImageParam;


typedef enum
{
    IF_0 = 0,
    IF_1,
    IF_2,
    IF_3,
    IF_4,
    IF_5,
    IF_6,
    IF_7,
    IF_8,
    IF_9,
    IF_10,
    IF_11,
    IF_12,
    IF_13,
    IF_14,
    IF_15,
    IF_16,
    IF_17,
    IF_18,
    IF_19,
    IF_20,
    IF_21,
    IF_22,
    IF_23,
    IF_24,
    IF_25,
    IF_26,
    IF_27,
    IF_28,
    IF_29,
    IF_30,
    IF_31,
    IF_32,
    IF_33,
    IF_34,
    IF_35,
    
    IF_36,
    IF_37,
    IF_38,
    IF_39,
    IF_40,
    IF_41,
    IF_42,
    IF_43,
    IF_44,
    IF_45,
    IF_46,
    IF_47,
    IF_48,
    IF_49,
    IF_50,
    IF_51,
    IF_52,
    IF_53,
    IF_54,
    IF_55,
    IF_56,
    IF_57,
    IF_58,
    IF_59,
    IF_60,
    IF_61,
    IF_62,
    IF_63,
    IF_64,
    IF_65,
    IF_66,
    IF_67,
    IF_68,
    IF_69,
    IF_70,
    IF_71,
    IF_72,
    IF_73,
    IF_74,
    IF_75,
    IF_76,
    IF_77,
    IF_78,
    IF_79,
    IF_80,
    IF_81,
    IF_82,
    IF_83,
    IF_84,
    IF_85,
    IF_86,
    IF_87,
    IF_88,
    IF_89,
    IF_90,
    IF_91,
    IF_92,
    IF_93,
    IF_94,
    
    IF_95,
    IF_96,
    IF_97,
    IF_98,
    IF_99,
    
    IF_100,
    IF_101,
    IF_102,
    IF_103,
    IF_104,
    IF_105,
    IF_106,
    IF_107,
    IF_108,
    IF_109,
    
    IF_110,
    IF_111,
    IF_112,
    IF_113,
    IF_114,
    IF_115,
    IF_116,
    IF_117,
    IF_118,
    IF_119,
    
    IF_120,
    IF_121,
    IF_122,
    IF_123,
    IF_124,
    IF_125,
    IF_126,
    IF_127,
    IF_128,
    IF_129,
    
    IF_130,
    IF_131,
    IF_132,
    IF_133,
    IF_134,
    IF_135,
    IF_136,
    IF_137,
    IF_138,
    IF_139,
    
    IF_140,
    IF_141,
    IF_142,
    IF_143,
    IF_144,
    IF_145,
    IF_146,
    IF_147,
    IF_148,
    IF_149,
    
    IF_150,
    IF_151,
    IF_152,
    IF_153,
    IF_154,
    IF_155,
    IF_156,
    IF_157,
    IF_158,
    IF_159,
    
    IF_160,
    IF_161,
    IF_162,
    IF_163,
    IF_164,
    IF_165,
    IF_166,
    IF_167,
    IF_168,
    IF_169,
    
    IF_170,
    IF_171,
    IF_172,
    IF_173,
    IF_174,
    IF_175,
    IF_176,
    IF_177,
    IF_178,
    IF_179,
    
    IF_180,
    IF_181,
    IF_182,
    IF_183,
    IF_184,
    IF_185,
    IF_186,
    IF_187,
    IF_188,
    IF_189,
    
    IF_190,
    IF_191,
    IF_192,
    IF_193,
    IF_194,
    IF_195,
    IF_196,
    IF_197,
    IF_198,
    IF_199,
    
    IF_200,
    IF_201,
    IF_202,
    IF_203,
    IF_204,
    IF_205,
    IF_206,
    IF_207,
    IF_208,
    IF_209,
    
    IF_210,
    IF_211,
    IF_212,
    IF_213,
    IF_214,
    IF_215,
    IF_216,
    IF_217,
    IF_218,
    IF_219,
    
    IF_220,
    IF_221,
    IF_222,
    IF_223,
    IF_224,
    IF_225,
    IF_226,
    IF_227,
    IF_228,
    IF_229,
    
    IF_230,
    IF_231,
    IF_232,
    IF_233,
    IF_234,
    IF_235,
    IF_236,
    IF_237,
    IF_238,
    IF_239,
    
    IF_240,
    IF_241,
    IF_242,
    IF_243,
    IF_244,
    IF_245,
    IF_246,
    IF_247,
    IF_248,
    IF_249,
    
    IF_250,
    IF_251,
    IF_252,
    IF_253,
    IF_254,
    IF_255,
    IF_256,
    IF_257,
    IF_258,
    IF_259,
    
    NC_FILTER_TOTAL_NUMBER
} NCFilterType;

#endif
