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

@interface EditViewController () <IFVideoCameraDelegate,ImageEditViewDelegate,
                                     UIAlertViewDelegate>
{
    NSMutableArray *_patternImages;
    NCVideoCamera *_videoCamera;
    BOOL _isShowTemplateNav;
    TemplateType _templateType;
    //用于adjust image时使用,（在滤镜效果的基础上再作调整）
    NSMutableArray *_filterImages;
    __block bool _filtering;
    ImageEditView *_imageEditView;
    GPUImageView *captureView;
    NCFilterType filter_type;
    NCFilterType last_filter_type;
    float lastValue;
    UIImageView *origin_imageView;
    CGFloat current_intensity;
    UIImage *resultImage;
    BOOL isOrigin;
    BOOL isRandom;
    UIButton *topConfirmBtn;
    UIButton *topCancelBtn;
}

@property (nonatomic, strong) TemplatModel *templateModel;

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
    isRandom = YES;
    
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

    captureView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, kNavBarH, windowWidth(), height)];
    captureView.center = CGPointMake(windowWidth()/2.f,kNavBarH + height/2.f);
    captureView.fillMode = kGPUImageFillModePreserveAspectRatio;
    captureView.hidden = YES;
    captureView.userInteractionEnabled = NO;
    
    origin_imageView = [[UIImageView alloc] initWithFrame:captureView.frame];
    origin_imageView.hidden = YES;
    origin_imageView.contentMode = UIViewContentModeScaleAspectFit;
    origin_imageView.image = self.srcImage;
    
    //滤镜相关
    _videoCamera = [[NCVideoCamera alloc] initWithImage:[PRJ_Global shareStance].compressionImage andOutputView:captureView];
    _videoCamera.photoDelegate = self;
    _videoCamera.stillCameraDelegate = self;
    last_filter_type = (NCFilterType)111;
    [_videoCamera switchFilterType:last_filter_type value:1.f];
    
    RC_ShowImageView *show_imageView = [[RC_ShowImageView alloc] initWithFrame:captureView.frame];
    show_imageView.contentMode = UIViewContentModeScaleAspectFit;
    show_imageView.image = self.srcImage;
    [show_imageView receiveRandomNumber:^(NSInteger number) {
        captureView.hidden = YES;
        isRandom = YES;
        NCFilterType type = (NCFilterType)number;
        [self handleFilterData:type isRandomFilter:YES];
    }];
    
    [self.view addSubview:show_imageView];
    [self.view addSubview:captureView];
    [self.view addSubview:origin_imageView];

    UIButton *ab_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ab_btn setFrame:CGRectMake(windowWidth() - 44.5f, windowHeight() - 167.f, 44.5f, 37)];
    [ab_btn setImage:[UIImage imageNamed:@"fe_btn_AB_normal"] forState:UIControlStateNormal];
    [ab_btn setImage:[UIImage imageNamed:@"fe_btn_AB_normal"] forState:UIControlStateHighlighted];
    [ab_btn addTarget:self action:@selector(abbtnClickInside) forControlEvents:UIControlEventTouchDown];
    [ab_btn addTarget:self action:@selector(abbtnClickOutside) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.view addSubview:ab_btn];
    
    //nav
    CGFloat itemWH = kNavBarH;
    //顶部确定取消按钮、底部弹模板界面按钮
    topConfirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, itemWH, itemWH)];
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

- (void)showTools
{
    topCancelBtn.hidden = NO;
    topConfirmBtn.hidden = NO;
}

- (void)hideTools
{
    topCancelBtn.hidden = YES;
    topConfirmBtn.hidden = YES;
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
- (void)videoCameraResultImage:(NSArray *)array
{
    if (isOrigin)
    {
        resultImage = nil;
        resultImage = array.firstObject;
        [self filterBestImage];
        isOrigin = NO;
    }
    else if (isRandom)
    {
        edit_global.filterResultImage(array.firstObject);
        isRandom = !isRandom;
    }
}

- (void)stillCameraResultImage:(UIImage *)image
{
    NSLog(@"result");
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 100)//退出编辑
    {
        if (buttonIndex == 0) {
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
#pragma mark - 合成图片
- (void)creatBaseImage:(CreatBaseImage)baseImage
{
    self.produceBaseImage = baseImage;
    isOrigin = YES;
    NCFilterType type = captureView.hidden ? last_filter_type : filter_type;
    [_videoCamera setImage:[PRJ_Global shareStance].originalImage WithFilterType:type andValue:current_intensity];
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
        
        CGSize contextSize = CGSizeMake(resultImage.size.width, resultImage.size.height);
        UIGraphicsBeginImageContextWithOptions(contextSize, YES, 1.0);
        [resultImage drawInRect:CGRectMake(0, 0, contextSize.width, contextSize.height)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //去黑框
        {
            CGFloat scaleW = 1;
            CGFloat scaleH = 1;
            
            switch (_aspectRatio)
            {
                case kAspectRatioFree:
                    scaleW = [PRJ_Global shareStance].freeScale;
                    scaleH = 1;
                    break;
                    
                case kAspectRatio1_1:
                    break;
                    
                case kAspectRatio2_3:
                    scaleW = 2;
                    scaleH = 3;
                    break;
                    
                case kAspectRatio3_2:
                    scaleW = 3;
                    scaleH = 2;
                    break;
                    
                case kAspectRatio3_4:
                    scaleW = 3;
                    scaleH = 4;
                    break;
                    
                case kAspectRatio4_3:
                    scaleW = 4;
                    scaleH = 3;
                    break;
                    
                case kAspectRatio9_16:
                    scaleW = 9;
                    scaleH = 16;
                    break;
                    
                case kAspectRatio16_9:
                    scaleW = 16;
                    scaleH = 9;
                    break;
                    
                default:
                    break;
            }
            
            CGFloat w = image.size.width;
            CGFloat h = image.size.height;
            if(scaleW > scaleH)
            {
                h = w / (scaleW / scaleH);
            }
            else
            {
                w = h * (scaleW / scaleH);
            }
            CGFloat x = (image.size.width - w ) * 0.5;
            CGFloat y = (image.size.height - h ) * 0.5;
            image = [image subImageWithRect:CGRectMake(x, y, w - 1, h)];
        }
        
        //指定像素
        image = [image rescaleImageToSize:outputSize];
        
        //是否加水印
        UIImageView *waterMarkImageView = nil;
        NSString *waterMark = [[NSUserDefaults standardUserDefaults] objectForKey:UDKEY_WATERMARKSWITCH];
        if(!waterMark ||(waterMark && [waterMark intValue]) )
        {
            CGFloat imageViewW = image.size.width * (1.0f/5.f);
            CGFloat imageViewH = imageViewW * (41.f/303.f);
            
            CGFloat imageViewX = image.size.width - imageViewW - 4;
            CGFloat imageViewY = image.size.height - imageViewH - 4;
            waterMarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
            waterMarkImageView.image = [UIImage imageNamed:@"Watermark_bg"];
            
            UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
            [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)]; // scales image to rect
            [waterMarkImageView.image drawInRect:waterMarkImageView.frame];
            image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
        }
        
        if (_produceBaseImage)
        {
            _produceBaseImage(image);
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
            if (random)
            {
                last_filter_type = filter_type;
            }
            filter_type = (NCFilterType)filterId;
            _imageEditView.starValue = starProgress;
            _imageEditView.endValue = endProgress;
            [_videoCamera switchFilterType:filter_type value:defaultProgress];
        }
    }
}

#pragma mark -
#pragma mark - ImageEditViewDelegate
- (void)imageEditView:(ImageEditView *)imageEditView ChangeFilterId:(NSInteger)filterId
{
    if (![PRJ_Global shareStance].isDragging)
    {
        captureView.hidden = NO;
        [self handleFilterData:filterId isRandomFilter:NO];
    }
    [PRJ_Global shareStance].isDragging = NO;
}

-(void)imageEditView:(ImageEditView *)imageEditView ChangeFilterIntensity:(CGFloat)intensity WithFilterId:(NSInteger)filterId
{
    current_intensity = intensity;
    [_videoCamera updateFilterParmas:intensity];
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
#pragma mark - 强度完成和取消按钮
- (void)imageEditViewRecover:(BOOL)recover
{
    if (recover)
    {
        [_videoCamera updateFilterParmas:lastValue];
    }
}

- (void)dealloc
{
    self.srcImage = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
