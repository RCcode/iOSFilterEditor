//
//  EditViewController.m
//  FilterGrid
//
//  Created by herui on 4/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "EditViewController.h"
#import "UIImage+SubImage.h"
#import "NCVideoCamera.h"
#import "UIButton+helper.h"
#import "ShareViewController.h"
#import "PRJ_Global.h"
#import "CMethods.h"
#import "IS_Tools.h"
#import "ImageEditView.h"
#import "RC_ShowImageView.h"
#import "RCGuideView.h"
#import "UIImage+Extensions.h"
#import "UIDevice+DeviceInfo.h"

@interface EditViewController () <IFVideoCameraDelegate,ImageEditViewDelegate,
                                     UIAlertViewDelegate>
{
    NSMutableArray *_patternImages;
    NCVideoCamera *_videoCamera;
    BOOL _isShowTemplateNav;
    //用于adjust image时使用,（在滤镜效果的基础上再作调整）
    NSMutableArray *_filterImages;
    ImageEditView *_imageEditView;
    NCFilterType filter_type;
    float lastValue;
    UIImageView *origin_imageView;
    float current_intensity;
    UIImage *resultImage;
    BOOL isOrigin;
    UIButton *topConfirmBtn;
    UIButton *topCancelBtn;
    NSInteger selectedBtnTag;
    RC_ShowImageView *show_imageView;
    UIButton *ab_btn;
    BOOL isHave;
}

@property (nonatomic ,strong) GPUImageView *captureView;
@property (nonatomic ,assign) BOOL isRandom;

@end

@implementation EditViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    hideLoadingView();
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = colorWithHexString(@"#2f2f2f");
    _isRandom = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTools) name:@"showTools" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTools) name:@"hideTools" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(abbtnClickOutside) name:@"restoreState" object:nil];
    
    CGFloat imageEditViewH = 130;
    CGFloat imageEditViewY = kWinSize.height;
    CGFloat imageEditViewW = kWinSize.width;
    
    _imageEditView = [[ImageEditView alloc] initWithFrame:CGRectMake(0, imageEditViewY, imageEditViewW, imageEditViewH)];
    _imageEditView.delegate = self;
    [self.view addSubview:_imageEditView];

    [_imageEditView hideFilterIntensitySliderView];
    [IS_Tools ViewAnimation:_imageEditView withFrame:CGRectMake(0, imageEditViewY - imageEditViewH, imageEditViewW, imageEditViewH)];
 
    float height = ScreenHeight - imageEditViewH - kNavBarH;
    
    CGSize size = workImageSize(self.srcImage.size.width, self.srcImage.size.height, windowWidth(), height);
    self.captureView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, kNavBarH, size.width, size.height)];
    _captureView.center = CGPointMake(windowWidth()/2.f,kNavBarH + height/2.f);
    _captureView.fillMode = kGPUImageFillModePreserveAspectRatio;
    _captureView.userInteractionEnabled = NO;
    
    origin_imageView = [[UIImageView alloc] initWithFrame:_captureView.frame];
    origin_imageView.hidden = YES;
    origin_imageView.contentMode = UIViewContentModeScaleAspectFit;
    origin_imageView.image = self.srcImage;
    
    //滤镜相关
    _videoCamera = [[NCVideoCamera alloc] initWithImage:[PRJ_Global shareStance].compressionImage andOutputView:_captureView];
    _videoCamera.photoDelegate = self;
    _videoCamera.stillCameraDelegate = self;
    [PRJ_Global shareStance].last_random_filter_type = (NCFilterType)111;
    [PRJ_Global shareStance].filterTitle = @"L3";
    [_videoCamera switchFilterType:[PRJ_Global shareStance].last_random_filter_type value:1.f];
    current_intensity = 1.0;
    
    show_imageView = [[RC_ShowImageView alloc] initWithFrame:_captureView.frame];
    show_imageView.contentMode = UIViewContentModeScaleAspectFit;
    show_imageView.image = self.srcImage;
    
    __weak EditViewController *weakSelf = self;
    [[PRJ_Global shareStance] receiveRandomNumber:^(NSInteger number,BOOL isNeedFilter) {
        isHave = NO;
        [_videoCamera.gpuImageView removeFromSuperview];
        if (!isNeedFilter)
            return ;
        weakSelf.isRandom = YES;
        NCFilterType type = (NCFilterType)number;
        [weakSelf handleFilterData:type isRandomFilter:YES];
    }];
    
    [self.view addSubview:show_imageView];
    [self.view addSubview:origin_imageView];

    ab_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ab_btn setFrame:CGRectMake(windowWidth() - 44.5f, windowHeight() - 167.f, 44.5f, 37)];
    [ab_btn setImage:[UIImage imageNamed:@"fe_btn_AB_normal"] forState:UIControlStateNormal];
    [ab_btn setImage:[UIImage imageNamed:@"fe_btn_AB_normal"] forState:UIControlStateHighlighted];
    [ab_btn addTarget:self action:@selector(abbtnClickInside) forControlEvents:UIControlEventTouchDown];
    [ab_btn addTarget:self action:@selector(abbtnClickOutside) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.view addSubview:ab_btn];
    
    //nav
    CGFloat itemWH = kNavBarH;
    //顶部确定取消按钮、底部弹模板界面按钮
    topConfirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemWH, itemWH)];
    [self.view addSubview:topConfirmBtn];
    [topConfirmBtn setImage:[UIImage imageNamed:@"fe_btn_share_pressed"] forState:UIControlStateHighlighted];
    [topConfirmBtn setImage:[UIImage imageNamed:@"fe_btn_share_normal"] forState:UIControlStateNormal];
    topConfirmBtn.center = CGPointMake(kWinSize.width - (itemWH * 0.5)-10, (itemWH * 0.5));
    [topConfirmBtn addTarget:self action:@selector(confirmBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    topCancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, itemWH, itemWH)];
    [self.view addSubview:topCancelBtn];
    [topCancelBtn setImage:[UIImage imageNamed:@"fe_btn_back_pressed"] forState:UIControlStateHighlighted];
    [topCancelBtn setImage:[UIImage imageNamed:@"fe_btn_back_normal"] forState:UIControlStateNormal];
    topCancelBtn.center = CGPointMake(10+(itemWH * 0.5), (itemWH * 0.5));
    [topCancelBtn addTarget:self action:@selector(cancelBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BOOL showGuideImage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isShowGuideImage"] boolValue];
    if (!showGuideImage)
    {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        RCGuideView *guideView = [[RCGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [window addSubview:guideView];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isShowGuideImage"];
    }
}

- (void)showTools
{
    topCancelBtn.hidden = NO;
    topConfirmBtn.hidden = NO;
}

- (void)hideTools
{
    topCancelBtn.hidden = YES;
    topConfirmBtn.hidden = YES;
    [self.view addSubview:_videoCamera.gpuImageView];
    [self.view bringSubviewToFront:origin_imageView];
    [self.view bringSubviewToFront:ab_btn];
}

- (void)abbtnClickInside
{
    origin_imageView.hidden = NO;
}

- (void)abbtnClickOutside
{
    origin_imageView.hidden = YES;
}

- (void)leftBarButtonItemClick
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 界面仨按钮点击动作
- (void)confirmBtnOnClick
{
    [PRJ_Global event:@"edit_done" label:@"Edit"];    
    //弹分享界面
    ShareViewController *shareVC = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    shareVC.aspectRatio = _aspectRatio;
    shareVC.editCtr = self;
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (void)cancelBtnOnClick
{
    [PRJ_Global event:@"edit_cancel" label:@"Edit"];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:LocalizedString(@"alert_quit_edit", nil) delegate:self cancelButtonTitle:LocalizedString(@"edit_quit", nil) otherButtonTitles:LocalizedString(@"edit_continue", nil), nil];
    alert.tag = 100;
    [alert show];
}

static EditViewController *edit_global;
+ (void)receiveFilterResult:(ResiveFilerResult)resultImage
{
    if (!edit_global)
    {
        edit_global = [[EditViewController alloc] init];
    }
    edit_global.filterResultImage = resultImage;
}

#pragma mark - IFVideoCameraDelegate
- (void)videoCameraResultImage:(NSArray *)array filterType:(NCFilterType)currentType
{
    if (isOrigin)
    {
        resultImage = nil;
        resultImage = array.firstObject;
        [self filterBestImage];
        isOrigin = NO;
    }
    else if (_isRandom)
    {
        NSDictionary *dic = @{Kimage:array.firstObject,KFilterType:@(currentType),KStrongValue:@(current_intensity)};
        edit_global.filterResultImage(dic);
        _isRandom = NO;
    }
    else if (!_isRandom)
    {
        if ([PRJ_Global shareStance].filter_image_array.count > selectedBtnTag)
        {
            [[PRJ_Global shareStance].filter_image_array replaceObjectAtIndex:selectedBtnTag withObject:array.firstObject];
            show_imageView.image = array.firstObject;
            [PRJ_Global shareStance].last_random_filter_type = currentType;
            [PRJ_Global shareStance].strongValue = current_intensity;
        }
    }
}

- (void)videoCameraFrame:(CGRect)rawFrame FilterType:(NSInteger)filterID
{
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool
        {
            UIGraphicsBeginImageContext(_videoCamera.gpuImageView.bounds.size);
            [_videoCamera.gpuImageView drawViewHierarchyInRect:_videoCamera.gpuImageView.bounds afterScreenUpdates:YES];
            __weak UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            if (isOrigin)
            {
                resultImage = nil;
                resultImage = image;
                [self filterBestImage];
                isOrigin = NO;
            }
            else if (_isRandom)
            {
                NSDictionary *dic = @{[image copy]:@"image",@(filterID):@"filterType"};
                edit_global.filterResultImage(dic);
                _isRandom = NO;

            }
            else if (!_isRandom)
            {
                if ([PRJ_Global shareStance].filter_image_array.count > selectedBtnTag)
                {
                    [[PRJ_Global shareStance].filter_image_array replaceObjectAtIndex:selectedBtnTag withObject:image];
                    show_imageView.image = image;
                    [PRJ_Global shareStance].last_random_filter_type = (NCFilterType)filterID;
                    [PRJ_Global shareStance].strongValue = current_intensity;
                }
            }
        }
    });
}

- (void)stillCameraResultImage:(UIImage *)image
{
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 100)//退出编辑
    {
        if (buttonIndex == 0)
        {
            [PRJ_Global shareStance].groupType = 0;
            [PRJ_Global shareStance].draggingIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
    if(!buttonIndex)    return;
    //解锁模板时弹框
    
    switch (alertView.tag) {
        case kTemplateTypeGrid:
        {
            //解锁评价
            [PRJ_Global event:@"choosetemplate_rate_unlock" label:@"ChooseTemplate"];
            
            //跳评论
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreScoreURL]];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UDKEY_ReviewUnLock];
            
            //关闭评论提醒
            [[NSUserDefaults standardUserDefaults] setObject:@(-1) forKey:UDKEY_ShareCount];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
            break;
            
        case kTemplateTypeShape:
        {
            //解锁分享
            [PRJ_Global event:@"choosetemplate_share_unlock" label:@"ChooseTemplate"];
            
            //弹分享
            NSString *shareContent = @"需要分享的内容";
            NSArray *activityItems = @[shareContent];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            
            activityVC.completionHandler = ^(NSString *activityType,BOOL completed)
            {
                //分享成功则解锁
                if(completed)
                {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UDKEY_ShareUnLock];
                    [[NSNotificationCenter defaultCenter] postNotificationName:UNLOCK_BW object:[NSNumber numberWithInteger:5]];
                }
            };
            
            [self presentViewController:activityVC animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark 合成图片
- (void)creatBaseImage:(CreatBaseImage)baseImage
{
    self.produceBaseImage = baseImage;
    isOrigin = YES;
    NCFilterType type = [PRJ_Global shareStance].last_random_filter_type;
    NSLog(@"[PRJ_Global shareStance].strongValue.........%@",@([PRJ_Global shareStance].strongValue));
    [_videoCamera setImage:[PRJ_Global shareStance].originalImage WithFilterType:type andValue:[PRJ_Global shareStance].strongValue];
}

- (void)filterBestImage
{
    @autoreleasepool
    {
        //计算outputSize
        CGSize outputSize = CGSizeZero;
        switch ([PRJ_Global shareStance].outputResolutionType)
        {
            case kOutputResolutionType1080_1080:
            {
                switch (_aspectRatio) {
                    case kAspectRatioFree:
                        outputSize = CGSizeMake(1080 * [PRJ_Global shareStance].freeScale, 1080);
                        break;
                        
                    case kAspectRatio1_1:
                        outputSize = CGSizeMake(1080, 1080);
                        break;
                        
                    case kAspectRatio2_3:
                        outputSize = CGSizeMake(720, 1080);
                        break;
                        
                    case kAspectRatio3_2:
                        outputSize = CGSizeMake(1080, 720);
                        break;
                        
                    case kAspectRatio3_4:
                        outputSize = CGSizeMake(810, 1080);
                        break;
                        
                    case kAspectRatio4_3:
                        outputSize = CGSizeMake(1080, 810);
                        break;
                        
                    case kAspectRatio9_16:
                        outputSize = CGSizeMake(607, 1080);
                        break;
                        
                    case kAspectRatio16_9:
                        outputSize = CGSizeMake(1080, 607);
                        break;
                    default:
                        break;
                }
            }
                break;
            case kOutputResolutionType3240_3240:
            {
                switch (_aspectRatio)
                {
                    case kAspectRatioFree:
                        outputSize = CGSizeMake([PRJ_Global shareStance].maxScaleValue * [PRJ_Global shareStance].freeScale , [PRJ_Global shareStance].maxScaleValue);
                        break;
                        
                    case kAspectRatio1_1:
                        outputSize = CGSizeMake([PRJ_Global shareStance].maxScaleValue, [PRJ_Global shareStance].maxScaleValue);
                        break;
                        
                    case kAspectRatio2_3:
                        outputSize = CGSizeMake([PRJ_Global shareStance].maxScaleValue * (2.f/3.f), [PRJ_Global shareStance].maxScaleValue);
                        break;
                        
                    case kAspectRatio3_2:
                        outputSize = CGSizeMake([PRJ_Global shareStance].maxScaleValue, [PRJ_Global shareStance].maxScaleValue * (2.f/3.f));
                        break;
                        
                    case kAspectRatio3_4:
                        outputSize = CGSizeMake([PRJ_Global shareStance].maxScaleValue * (3.f/4.f), [PRJ_Global shareStance].maxScaleValue);
                        break;
                        
                    case kAspectRatio4_3:
                        outputSize = CGSizeMake([PRJ_Global shareStance].maxScaleValue, [PRJ_Global shareStance].maxScaleValue * (3.f/4.f));
                        break;
                        
                    case kAspectRatio9_16:
                        outputSize = CGSizeMake([PRJ_Global shareStance].maxScaleValue * (9.f/16.f), [PRJ_Global shareStance].maxScaleValue);
                        break;
                        
                    case kAspectRatio16_9:
                        outputSize = CGSizeMake([PRJ_Global shareStance].maxScaleValue, [PRJ_Global shareStance].maxScaleValue * (9.f/16.f));
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            default:
                break;
        }
        
        //是否加水印
        UIImageView *waterMarkImageView = nil;
        NSString *waterMark = [[NSUserDefaults standardUserDefaults] objectForKey:UDKEY_WATERMARKSWITCH];
        if(!waterMark ||(waterMark && [waterMark intValue]) )
        {
            CGFloat imageViewW = resultImage.size.width * (1.0f/5.f);
            CGFloat imageViewH = imageViewW * (41.f/303.f);
            
            CGFloat imageViewX = resultImage.size.width - imageViewW - 4;
            CGFloat imageViewY = resultImage.size.height - imageViewH - 4;
            waterMarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
            waterMarkImageView.image = [UIImage imageNamed:@"Watermark_bg"];
            
            //等比缩放
            CGSize origin_size = resultImage.size;
            if(origin_size.width < outputSize.width && origin_size.height < outputSize.height)
            {
                outputSize = origin_size;
            }
            
            CGRect rect = (CGRect){CGPointZero, outputSize};
            
            UIGraphicsBeginImageContextWithOptions(outputSize, NO, [UIScreen mainScreen].scale);
            
            [resultImage drawInRect:rect]; // scales image to rect
            [waterMarkImageView.image drawInRect:waterMarkImageView.frame];
            resultImage = UIGraphicsGetImageFromCurrentImageContext();

            UIGraphicsEndImageContext();
        }
        
        if (_produceBaseImage)
        {
            _produceBaseImage(resultImage);
        }
    }
}

- (void)imageEditViewGropName:(NSString *)name
{
    NSString *msg = LocalizedString(@"share_unlock_shape", nil);
    NSString *btnTitle = LocalizedString(@"immediately_share", nil);
    NSString *eventSubtitle = @"share";
    
    NSString *event = [NSString stringWithFormat:@"choosetemplate_%@", eventSubtitle];
    [PRJ_Global event:event label:@"ChooseTemplate"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:LocalizedString(@"cancel", nil)
                                              otherButtonTitles:btnTitle, nil];
    alertView.tag = kTemplateTypeShape;
    [alertView show];
}

- (void)handleFilterData:(NSInteger)filterId isRandomFilter:(BOOL)random
{
    NSString *fileName = [NSString stringWithFormat:@"com_rcplatform_filter_config_%ld",(long)filterId];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *keyArray = [dictionary allKeys];
    if ([keyArray containsObject:@"progressConfig"])
    {
        NSDictionary *dic = [dictionary objectForKey:@"progressConfig"];
        NSArray *keys = [dic allKeys];
        if ([keys containsObject:@"defaultProgress"])
        {
            float defaultProgress = [[dic objectForKey:@"defaultProgress"]integerValue]/100.0;
            float starProgress = [[dic objectForKey:@"startProgress"]integerValue]/100.0;
            float endProgress = [[dic objectForKey:@"endProgress"]integerValue]/100.0;
            lastValue = defaultProgress;
            current_intensity = defaultProgress;
            filter_type = (NCFilterType)filterId;
            _imageEditView.starValue = starProgress;
            _imageEditView.endValue = endProgress;
            [_videoCamera switchFilterType:filter_type value:defaultProgress];
        }
    }
    if ([keyArray containsObject:@"name"])
    {
        NSString *title = [dictionary objectForKey:@"name"];
        [PRJ_Global shareStance].filterTitle = title;
    }
}

#pragma mark -
#pragma mark ImageEditViewDelegate
- (void)imageEditView:(ImageEditView *)imageEditView ChangeFilterId:(NSInteger)filterId btnTag:(NSInteger)buttonTag
{
    selectedBtnTag = buttonTag;
    if (![PRJ_Global shareStance].isDragging)
    {
        isHave = YES;
        [self handleFilterData:filterId isRandomFilter:NO];
    }
    [PRJ_Global shareStance].isDragging = NO;
}

- (void)imageEditView:(ImageEditView *)imageEditView ChangeFilterIntensity:(CGFloat)intensity WithFilterId:(NSInteger)filterId
{
    [PRJ_Global shareStance].strongValue = intensity;
    [_videoCamera updateFilterParmas:intensity withProcess:YES];
}

- (void)imageEditView:(ImageEditView *)imageEditView AdjustImageWithAdjustImageParam:(AdjustImageParam)adjustImageParam
{
    
}

- (void)imageEditViewConfirm:(ImageEditView *)imageEditView
{
    CGFloat imageEditViewH = 100;
    CGFloat imageEditViewY = kWinSize.height;
    CGFloat imageEditViewW = kWinSize.width;
    [IS_Tools ViewAnimation:_imageEditView withFrame:CGRectMake(0, imageEditViewY, imageEditViewW, imageEditViewH)];
}

#pragma mark -
#pragma mark 强度完成和取消按钮
- (void)imageEditViewRecover:(BOOL)recover
{
    if (recover)
    {
        [_videoCamera updateFilterParmas:lastValue withProcess:YES];
    }
}

- (void)dealloc
{
    _srcImage = nil;
    _captureView = nil;
    _videoCamera = nil;
    _produceBaseImage = nil;
    _filterResultImage = nil;
    _imageEditView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
