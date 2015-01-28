//
//  ShareViewController.m
//  IOSNoCrop
//
//  Created by herui on 2/7/14.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "ShareViewController.h"
#import "UIButton+helper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PRJ_DataRequest.h"
#import <Social/Social.h>
#import "GADInterstitial.h"
#import "AppDelegate.h"
#import "UIImage+SubImage.h"
#import "CMethods.h"
#import "PRJ_Global.h"
#import "RC_moreAPPsLib.h"
#import "EditViewController.h"

#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define kToInstagramPath [kDocumentPath stringByAppendingPathComponent:@"NoCrop_Share_Image.igo"]
#define kToMorePath [kDocumentPath stringByAppendingPathComponent:@"NoCrop_Share_Image.jpg"]

@interface ShareViewController () <UIAlertViewDelegate, UIActionSheetDelegate>
{
    SLComposeViewController *slComposerSheet;
    NSInteger count;
    BOOL saved;
}

@property (strong ,nonatomic) UIDocumentInteractionController *documetnInteractionController;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareToInstaBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareToFac;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *watermarkLabel;

@property (weak, nonatomic) IBOutlet UIView *noCropBgView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoCrop;
@property (weak, nonatomic) IBOutlet UIImageView *imgNoCrop;
@property (weak, nonatomic) IBOutlet UIButton *btnNoCrop;
@property (weak, nonatomic) IBOutlet UISwitch *waterMarkSwitch;

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)dealloc
{
    [PRJ_Global shareStance].basicImage = nil;
}

- (void)leftBarButtonItemClick
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemClick
{
    if(saved)
    {
        [PRJ_Global shareStance].groupType = 0;
        [PRJ_Global shareStance].draggingIndex = 0;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:LocalizedString(@"alert_pic_have_not_save", nil) message:nil delegate:self cancelButtonTitle:LocalizedString(@"cancel", nil) otherButtonTitles:LocalizedString(@"confirm", nil), nil];
        alert.tag = 111;
        [alert show];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    showLoadingView(nil);
    _saveBtn.enabled = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"createBisicImage" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithInteger:count+1] forKey:showCount];
    [userDefault synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithHexString(@"#2f2f2f");

    _noCropBgView.layer.borderWidth = 3;
    _noCropBgView.layer.borderColor = colorWithHexString(@"#3b3b3b").CGColor;
    _noCropBgView.layer.cornerRadius = 10;
    _noCropBgView.backgroundColor = colorWithHexString(@"#2f2f2f");
    
    [_lblNoCrop setTextColor:colorWithHexString(@"#f8f8f8")];
    [_lblNoCrop setText:LocalizedString(@"btn_downLoadNoCrop_title", nil)];
    _lblNoCrop.numberOfLines = 0;
    [_watermarkLabel setTextColor:colorWithHexString(@"#a5a5a5")];
    _watermarkLabel.text = LocalizedString(@"show_app_watermark", nil);
    
    [_btnNoCrop setImage:[UIImage imageNamed:@"fe_icon_fg_normal"] forState:UIControlStateNormal];
    [_btnNoCrop setImage:[UIImage imageNamed:@"fe_icon_fg_pressed"] forState:UIControlStateHighlighted];
    [_btnNoCrop setTitle:LocalizedString(@"btn_downLoadNoCrop_title", nil) forState:UIControlStateNormal];
    [_btnNoCrop setTitleColor:colorWithHexString(@"#f8f8f8") forState:UIControlStateNormal];
    [_btnNoCrop setTitleColor:colorWithHexString(@"#ffffff") forState:UIControlStateHighlighted];
    _btnNoCrop.titleLabel.font = [UIFont systemFontOfSize:11];
    _btnNoCrop.titleLabel.numberOfLines = 0;
    _btnNoCrop.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    NSString *imageName = @"fe_btn_Share_facebook_normal";
    NSString *imageNameSel = @"fe_btn_Share_facebook_pressed";
    SEL action = @selector(shareToFacebook);
    
    [_shareToFac setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [_shareToFac setImage:[UIImage imageNamed:imageNameSel] forState:UIControlStateHighlighted];
    [_shareToFac addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    //nav init
    CGFloat itemWH = kNavBarH;
    UIButton *navBackItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemWH, itemWH)];
    [navBackItem setImage:[UIImage imageNamed:@"fe_icon_back_normal"] forState:UIControlStateNormal];
    [navBackItem setImage:[UIImage imageNamed:@"fe_icon_back_pressed"] forState:UIControlStateHighlighted];
    [navBackItem addTarget:self action:@selector(leftBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    navBackItem.imageView.contentMode = UIViewContentModeCenter;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navBackItem];
    
    UIButton *navRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemWH, itemWH)];
    [navRightBtn setImage:[UIImage imageNamed:@"fe_icon_home_normal"] forState:UIControlStateNormal];
    [navRightBtn setImage:[UIImage imageNamed:@"fe_icon_home_pressed"] forState:UIControlStateHighlighted];
    [navRightBtn addTarget:self action:@selector(rightBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    navRightBtn.imageView.contentMode = UIViewContentModeCenter;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    
    UILabel *fontLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    fontLabel.text = LocalizedString(@"share", @"");
    fontLabel.font = [UIFont fontWithName:kNavTitleFontName size:kNavTitleSize];
    fontLabel.textColor = [UIColor whiteColor];
    fontLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = fontLabel;
    
    NSString *waterMark = [[NSUserDefaults standardUserDefaults] objectForKey:UDKEY_WATERMARKSWITCH];
    if(!waterMark ||(waterMark && [waterMark intValue]) )
    {
        [_waterMarkSwitch setOn:YES];
    }
    else
    {
        [_waterMarkSwitch setOn:NO];
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    scrollView.frame = CGRectMake(0, CGRectGetMaxY(_watermarkLabel.frame)+20, kWinSize.width, kWinSize.height-CGRectGetMaxY(_watermarkLabel.frame)-20-kNavBarH);
    saved = NO;
    
    UIView *cellView = [[RC_moreAPPsLib shareAdManager] getShareView];
    cellView.center = CGPointMake(scrollView.frame.size.width/2.f, scrollView.frame.size.height/2.f);
    [scrollView addSubview:cellView];
}

#pragma mark - 应用评分
- (void)showAppScoreMsg
{
    //弹框
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    int shareCount = [[userDefault objectForKey:UDKEY_ShareCount] intValue];
    
    if(shareCount == -1)
    {
        return;
    }
    
    shareCount++;
    if((shareCount == 3) || (shareCount == 5)){//仅第3、第5次弹框
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:LocalizedString(@"comment_us", nil)
                                                       delegate:self
                                              cancelButtonTitle:LocalizedString(@"never_attention", nil)
                                              otherButtonTitles:LocalizedString(@"rate_now", nil), LocalizedString(@"comment_later", nil), nil];
        alert.tag = 112;
        [alert show];
    }
    
    if(shareCount > 5){
        shareCount = -1;
    }
    [userDefault setObject:@(shareCount) forKey:UDKEY_ShareCount];
    [userDefault synchronize];
}

#pragma mark - action methods
#pragma mark 水印开关
- (IBAction)watermarkChange:(UISwitch *)sender
{
    _saveBtn.enabled = YES;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",sender.isOn] forKey:UDKEY_WATERMARKSWITCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    showLoadingView(nil);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"createBisicImage" object:nil];
}

- (IBAction)save
{
    showLoadingView(nil);
    [PRJ_Global event:@"share_save" label:@"Share"];
    [PRJ_Global shareStance].showBackMsg = NO;
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"library_not_availabel", @"")
                                                        message:LocalizedString(@"user_library_step", @"")
                                                       delegate:nil
                                              cancelButtonTitle:LocalizedString(@"confirm", @"")
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    UIImageWriteToSavedPhotosAlbum([PRJ_Global shareStance].basicImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self showAppScoreMsg];
}

#pragma mark 分享到instagram
- (IBAction)shareToInsta
{
    [PRJ_Global event:@"share_instagram" label:@"Share"];
    [PRJ_Global shareStance].showBackMsg = NO;
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if (![[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:LocalizedString(@"instagram_not_installed", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:LocalizedString(@"confirm", nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    //保存本地 如果已存在，则删除
    if([[NSFileManager defaultManager] fileExistsAtPath:kToInstagramPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:kToInstagramPath error:nil];
    }

    NSData *imageData = UIImageJPEGRepresentation([PRJ_Global shareStance].basicImage, 0.8);
    [imageData writeToFile:kToInstagramPath atomically:YES];
    
    //分享
    NSURL *fileURL = [NSURL fileURLWithPath:kToInstagramPath];
    self.documetnInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    self.documetnInteractionController.UTI = @"com.instagram.exclusivegram";
    self.documetnInteractionController.annotation = @{@"InstagramCaption":kShareHotTags};
    [self.documetnInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

#pragma mark 分享到Line
- (void)shareToLine
{
    [PRJ_Global event:@"share_Line" label:@"Share"];
}

#pragma mark 分享到微信
- (void)shareToWeiXing
{
    [PRJ_Global event:@"share_winxin" label:@"Share"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"微信分享"
                                                             delegate:self
                                                    cancelButtonTitle:@"cancel"
                                               destructiveButtonTitle:@"朋友圈"
                                                    otherButtonTitles:@"会话", nil];
    [actionSheet showInView:self.view];
}

#pragma mark 分享到facebook
- (IBAction)shareToFacebook
{
    [PRJ_Global event:@"share_facebook" label:@"Share"];
    [PRJ_Global shareStance].showBackMsg = NO;

    slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    if([[NSFileManager defaultManager] fileExistsAtPath:kToMorePath]){
        [[NSFileManager defaultManager] removeItemAtPath:kToMorePath error:nil];
    }
    
    NSData *imageData = UIImageJPEGRepresentation([PRJ_Global shareStance].basicImage, 0.8);
    [imageData writeToFile:kToMorePath atomically:YES];
    UIImage *image = [UIImage imageWithContentsOfFile:kToMorePath];
    
    [slComposerSheet setInitialText:kShareHotTags];
    [slComposerSheet addImage:image];
    
    __weak SLComposeViewController *bSlComposerSheet = slComposerSheet;
    [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        [bSlComposerSheet dismissViewControllerAnimated:YES completion:Nil];
    }];
    
    if(slComposerSheet != nil){
        [self presentViewController:slComposerSheet animated:YES completion:nil];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"No Facebook Account" message:@"There are no Facebook accounts configured. You can add or create a Facebook account in Settings" delegate: nil cancelButtonTitle:LocalizedString(@"confirm", nil) otherButtonTitles:nil, nil] show];
    }
}

#pragma mark 分享到更多
- (IBAction)shareToMore
{
    [PRJ_Global event:@"share_more" label:@"Share"];
    [PRJ_Global shareStance].showBackMsg = NO;
    //保存本地 如果已存在，则删除
    if([[NSFileManager defaultManager] fileExistsAtPath:kToMorePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:kToMorePath error:nil];
    }
    
    NSData *imageData = UIImageJPEGRepresentation([PRJ_Global shareStance].basicImage, 0.8);
    [imageData writeToFile:kToMorePath atomically:YES];
    
    NSURL *fileURL = [NSURL fileURLWithPath:kToMorePath];
    _documetnInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    _documetnInteractionController.UTI = @"com.instagram.photo";
    _documetnInteractionController.annotation = @{@"InstagramCaption":@"来自NoCrop"};
    [_documetnInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
}

#pragma mark 分享到NoCrop
- (IBAction)shareToNoCrop
{
    [PRJ_Global event:@"share_nocrop" label:@"Share"];
    NSURL *url = [NSURL URLWithString:@"RCFilterGrid://"];
    if(![[UIApplication sharedApplication] canOpenURL:url])
    {
        //弹下载提示框
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:LocalizedString(@"alert_downLoadNoCrop", nil) delegate:self cancelButtonTitle:LocalizedString(@"cancel",nil) otherButtonTitles:LocalizedString(@"download_and_install",nil), nil];
        [alert show];
        return;
    }
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 111)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            [PRJ_Global shareStance].groupType = 0;
            [PRJ_Global shareStance].draggingIndex = 0;
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    else if (alertView.tag == 112)
    {
        if(buttonIndex == 0)
        {//取消不再提醒
            [PRJ_Global event:@"home_ratetip_cancel" label:@"Home"];
            return;
        }
        
        //没有点取消，不再弹
        [[NSUserDefaults standardUserDefaults] setObject:@(-1) forKey:UDKEY_ShareCount];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if(buttonIndex == 1){//马上评
            [PRJ_Global event:@"home_ratetip_like" label:@"Home"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreScoreURL]];
            return;
        }
        
        if(buttonIndex == 2){//
            [PRJ_Global event:@"home_ratetip_improve" label:@"Home"];
            [self feedBack];
        }

    }
    else if(buttonIndex == 0)
    {
        return;
    }
    
    [PRJ_Global event:@"share_nocrop_download" label:@"Share"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kNoCropAppStoreURL]];
}

-(void)feedBack
{
    //app名称 版本
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
    NSString *resolution = [NSString stringWithFormat:@"%.f * %.f", resolutionW, resolutionH];
    
    //本地语言
    NSString *language = [[NSLocale preferredLanguages] firstObject];
    
    NSString *diveceInfo = [NSString stringWithFormat:@"%@ %@, %@, %@ %@, %@, %@", app_Name, app_Version, deviceName, deviceSystemName, deviceSystemVer,  resolution, language];
    
    //直接发邮件
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    if(!picker) return;
    picker.mailComposeDelegate =self;
    NSString *subject = [NSString stringWithFormat:@"FilterGrid %@ (iOS)", LocalizedString(@"feedback", nil)];
    [picker setSubject:subject];
    [picker setToRecipients:@[kFeedbackEmail]];
    [picker setMessageBody:diveceInfo isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存相册反馈
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    hideLoadingView();
    if(!error)
    {
        _saveBtn.enabled = NO;
        saved = YES;
        MBProgressHUD *hud = showMBProgressHUD(LocalizedString(@"save_success", nil), NO);
        hud.removeFromSuperViewOnHide = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hideMBProgressHUD();
        });
    }
}

@end
