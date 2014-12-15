//
//  ScreenshotViewController.m
//  FilterGrid
//
//  Created by herui on 5/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "ScreenshotViewController.h"
#import "ScrrenshotToolBar.h"
#import "ScreenshotBorderView.h"
#import "UIButton+helper.h"
#import "EditViewController.h"
#import "PRJ_Global.h"
#import "CMethods.h"

@interface ScreenshotViewController () <ScrrenshotToolBarDelegate>
{
    ScrrenshotToolBar *_toolBar;
    ScreenshotBorderView *_screentshotView;
    AspectRatio _currAspectRatio;
}
@end

@implementation ScreenshotViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrrenshotToolBar:nil ItemOnClick:kAspectRatioFree];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.navigationController.navigationBar setBarTintColor:colorWithHexString(@"#232323")];
    //nav
    CGFloat itemWH = 35;
    UIButton *navBackItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemWH, itemWH)];
    [navBackItem setImage:[UIImage imageNamed:@"fe_btn_x_pressed"] forState:UIControlStateHighlighted];
    [navBackItem setImage:[UIImage imageNamed:@"fe_btn_x_normal"] forState:UIControlStateNormal];
    [navBackItem addTarget:self action:@selector(leftBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navBackItem];
    
    UIButton *navRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemWH, itemWH)];
    [navRightBtn setImage:[UIImage imageNamed:@"fe_btn_right_pressed"] forState:UIControlStateHighlighted];
    [navRightBtn setImage:[UIImage imageNamed:@"fe_btn_right_normal"] forState:UIControlStateNormal];
    [navRightBtn addTarget:self action:@selector(rightBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    
    //底部工具栏
    CGFloat toolBarW = self.view.bounds.size.width;
    CGFloat toolBarY = kWinSize.height - 44 - 50;
    _toolBar = [[ScrrenshotToolBar alloc] initWithFrame:CGRectMake(0, toolBarY, toolBarW, 50)];
    [self.view addSubview:_toolBar];
    _toolBar.delegate = self;

    CGFloat imageViewW = kWinSize.width;
    CGFloat imageViewH = kWinSize.height - kNavBarH - 50;
    _screentshotView = [[ScreenshotBorderView alloc] initWithFrame:CGRectMake(0, 0, imageViewW, imageViewH)];
    _screentshotView.srcImage = _srcImage;
    [self.view addSubview:_screentshotView];
}

- (void)leftBarButtonItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemClick
{
    switch (_currAspectRatio)
    {
        case kAspectRatioFree:
            [PRJ_Global event:@"crop_Free" label:@"Crop"];
            break;
        case kAspectRatio1_1:
            [PRJ_Global event:@"crop_1:1" label:@"Crop"];
            break;
        case kAspectRatio2_3:
            [PRJ_Global event:@"crop_2:3" label:@"Crop"];
            break;
        case kAspectRatio3_2:
            [PRJ_Global event:@"crop_3:2" label:@"Crop"];
            break;
        case kAspectRatio3_4:
            [PRJ_Global event:@"crop_3:4" label:@"Crop"];
            break;
        case kAspectRatio4_3:
            [PRJ_Global event:@"crop_4:3" label:@"Crop"];
            break;
        case kAspectRatio9_16:
            [PRJ_Global event:@"crop_9:16" label:@"Crop"];
            break;
        case kAspectRatio16_9:
            [PRJ_Global event:@"crop_16:9" label:@"Crop"];
            break;
        default:
            break;
    }

    EditViewController *editVC = [[EditViewController alloc] init];
    UIImage *shot_image = [_screentshotView subImage];
    [PRJ_Global shareStance].compressionImage = shot_image;
    [PRJ_Global shareStance].freeScale = shot_image.size.width/shot_image.size.height;
    editVC.srcImage = shot_image;
    editVC.aspectRatio = _currAspectRatio;

    [self.navigationController pushViewController:editVC animated:YES];
    showLoadingView(nil);
}

#pragma mark - ScrrenshotToolBarDelegate
- (void)scrrenshotToolBar:(ScrrenshotToolBar *)toolBar ItemOnClick:(AspectRatio)aspectRatio
{
    _currAspectRatio = aspectRatio;
    [_screentshotView setCameraCropStyle:_currAspectRatio];
}

@end
