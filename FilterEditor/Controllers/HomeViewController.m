//
//  HomeViewController.m
//  FilterGrid
//
//  Created by herui on 4/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "HomeViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+SubImage.h"
#import "APBaseNavigationController.h"
#import "ScreenshotViewController.h"
#import "ME_MoreAppViewController.h"
#import "RC_SettingViewController.h"
#import "CMethods.h"
#import "Common.h"
#import "PRJ_Global.h"

@interface HomeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIButton *moreBtn;
}
@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    UIImageView *bgImageView = [[UIImageView alloc]init];
    [bgImageView setFrame:self.view.bounds];
    
    if (kScreen3_5) {
        [bgImageView setImage:jpgImagePath(@"fg_bg_960@2x")];
    }
    else if (kScreen4_0){
        [bgImageView setImage:jpgImagePath(@"fg_bg_1136@2x")];
    }
    else
    {
        [bgImageView setImage:jpgImagePath(@"fg_bg_1242@3x")];
    }
    [self.view addSubview:bgImageView];
    
    //相机
    CGFloat cameraBtnW = 100;
    CGFloat cameraBtnH = 40;
    CGFloat cameraBtnY = kWinSize.height - 140;
    CGFloat cameraBtnX = (kWinSize.width - (cameraBtnW * 2)) /3;
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraBtn setFrame:CGRectMake(cameraBtnX, cameraBtnY, cameraBtnW, cameraBtnH)];
    [self.view addSubview:cameraBtn];
    [cameraBtn addTarget:self action:@selector(cameraBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [cameraBtn setImage:[UIImage imageNamed:@"fe_icon_camera"] forState:UIControlStateNormal];
    
    UILabel *lblCamera = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(cameraBtn.frame), CGRectGetMaxY(cameraBtn.frame), 100, 20)];
    [lblCamera setText:LocalizedString(@"camera", nil)];
    [lblCamera setTextAlignment:NSTextAlignmentCenter];
    [lblCamera setTextColor:[UIColor whiteColor]];
    [lblCamera setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:lblCamera];
    
    //相册
    CGFloat photoAlbumBtnX = kWinSize.width - cameraBtnX-cameraBtnW;
    UIButton *photoAlbumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoAlbumBtn setFrame:CGRectMake(photoAlbumBtnX, cameraBtnY, cameraBtnW, cameraBtnH)];
    [self.view addSubview:photoAlbumBtn];
    [photoAlbumBtn addTarget:self action:@selector(photoAlbumBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [photoAlbumBtn setImage:[UIImage imageNamed:@"fe_icon_album"] forState:UIControlStateNormal];

    UILabel *lblPhotoAlbum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(photoAlbumBtn.frame), CGRectGetMaxY(photoAlbumBtn.frame), 100, 20)];
    [lblPhotoAlbum setText:LocalizedString(@"gallery", nil)];
    [lblPhotoAlbum setTextAlignment:NSTextAlignmentCenter];
    [lblPhotoAlbum setTextColor:[UIColor whiteColor]];
    [lblPhotoAlbum setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:lblPhotoAlbum];
    
    //setting
    CGFloat BottomBtnW = 90;
    CGFloat BottomBtnH = 40;
    CGFloat cap = (kWinSize.width -BottomBtnW*3)/2;
    
    CGFloat settingBtnY = CGRectGetMaxY(lblCamera.frame)+30;
    CGFloat settingBtnX = 0;
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(settingBtnX, settingBtnY, BottomBtnW, BottomBtnH)];
    [settingBtn addTarget:self action:@selector(settingBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setImage:[UIImage imageNamed:@"fe_icon_set up"] forState:UIControlStateNormal];
    [self.view addSubview:settingBtn];

    //insta
    CGFloat instaBtnX = CGRectGetMaxX(settingBtn.frame)+cap;
    UIButton *instaBtn = [[UIButton alloc] initWithFrame:CGRectMake(instaBtnX, settingBtnY, BottomBtnW, BottomBtnH)];
    [self.view addSubview:instaBtn];
    [instaBtn addTarget:self action:@selector(instaBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [instaBtn setImage:[UIImage imageNamed:@"fe_icon_instagram+"] forState:UIControlStateNormal];
    
    //more
    CGFloat moreBtnX = CGRectGetMaxX(instaBtn.frame)+cap;
    moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(moreBtnX, settingBtnY, BottomBtnW, BottomBtnH)];
    [self.view addSubview:moreBtn];
    [moreBtn addTarget:self action:@selector(moreBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImage:[UIImage imageNamed:@"fe_icon_more apps"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMoreImageView) name:@"addMoreImage" object:nil];
}

- (void)addMoreImageView
{
    UIImageView *redImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 5, 10, 10)];
    redImageView.image = [UIImage imageNamed:@"spot"];
    redImageView.tag = 11;
    [moreBtn addSubview:redImageView];
}

- (void)removeMoreImageView
{
    UIView *imageView = [moreBtn viewWithTag:11];
    [imageView removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *pickerDismiss = [[NSUserDefaults standardUserDefaults]objectForKey:@"pickerDismiss"];
    if (pickerDismiss && [pickerDismiss isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"pickerDismiss"];
        return;
    }
}

#pragma mark - More
- (void)moreBtnOnClick{
    [PRJ_Global event:@"home_more" label:@"Home"];
    [self removeMoreImageView];
    ME_MoreAppViewController *moreVC = [[ME_MoreAppViewController alloc] init];
    UINavigationController *nav = [[APBaseNavigationController alloc] initWithRootViewController:moreVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 跳公司insta帐号
- (void)instaBtnOnClick{
    [PRJ_Global event:@"home_instagram" label:@"Home"];
    
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://user?username=%@", kFollwUsAccount]];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kFollwUsURL]];
    }
}

- (void)settingBtnOnClick{
    [PRJ_Global event:@"home_setting" label:@"Home"];
    RC_SettingViewController *settingVC = [[RC_SettingViewController alloc] init];
    UINavigationController *nav = [[APBaseNavigationController alloc] initWithRootViewController:settingVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)cameraBtnOnClick{
    [PRJ_Global event:@"home_camera" label:@"Home"];
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        return;
    }

    //判断权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"camena_not_availabel", @"")
                                                        message:LocalizedString(@"user_camera_step", @"")
                                                       delegate:nil
                                              cancelButtonTitle:LocalizedString(@"confirm", @"")
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = NO;
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (void)photoAlbumBtnOnClick{
    [PRJ_Global event:@"home_library" label:@"Home"];
    
    //判断权限
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
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = NO;
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)loadImageFromAssertByUrl:(NSURL *)url completion:(void (^)(UIImage *))completion{
    
    __block UIImage* img;
    
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)
     {
         ALAssetRepresentation *rep = [asset defaultRepresentation];
         Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
         NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(unsigned int)rep.size error:nil];
         NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
         img = [UIImage imageWithData:data];
         completion(img);
         
     } failureBlock:^(NSError *err) {
         NSLog(@"Error: %@",[err localizedDescription]);
     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    __weak UIImagePickerController *weekImagePickerController = picker;
    __weak HomeViewController *homeViewController = self;
    
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"pickerDismiss"];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    image = [self scaleAndRotateImage:image];
    
    void(^complationBlock)(UIImage *img) = ^(UIImage *img){
        
        
        CGFloat outputPX = 1080;
        switch ([PRJ_Global shareStance].outputResolutionType) {
                
            case kOutputResolutionType1660_1660:
                outputPX = 1660;
                break;
                
            case kOutputResolutionType2160_2160:
                outputPX = 2160;
                break;
                
            default:
                break;
        }
        
        UIImage *srcImage = [img rescaleImageToPX:outputPX];
        
        [weekImagePickerController dismissViewControllerAnimated:YES completion:^{
            
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            ScreenshotViewController *screenshotVC = [[ScreenshotViewController alloc] init];
            
            [PRJ_Global shareStance].freeScale = srcImage.size.width/srcImage.size.height;
            screenshotVC.srcImage = srcImage;
            [homeViewController.navigationController pushViewController:screenshotVC animated:YES];
            
            weekImagePickerController.delegate = nil;
            [weekImagePickerController.navigationController popViewControllerAnimated:NO];
        }];
    };
    
    if(image == nil)
    {
        NSURL *path = [info objectForKey:UIImagePickerControllerReferenceURL];
        [self loadImageFromAssertByUrl:path completion:complationBlock];
    }
    
    complationBlock(image);
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        picker.delegate = nil;
        [picker.navigationController popViewControllerAnimated:NO];
    }];
}

@end
