//
//  RC_SettingViewController.m
//  FilterGrid
//
//  Created by TCH on 14-11-5.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "RC_SettingViewController.h"
#import "RC_SettingCell.h"
#import "MessageUI/MessageUI.h"
#import "CMethods.h"
#import "PRJ_Global.h"

typedef enum{
    kSettingItemTypeResolution = 0, //分辨率
    kSettingItemTypeUpdate,         //升级
    kSettingItemTypeEvaluation,     //评价
    kSettingItemTypeFeedback,       //反馈
    kSettingItemTypeShare,          //分享
    
    SettingItemTypeTotalNumber
} SettingItemType;

@interface RC_SettingViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
    NSArray *_titles;
}
@end

@implementation RC_SettingViewController

- (void)leftBarButtonItemClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.font = [UIFont fontWithName:kNavTitleFontName size:kNavTitleSize];
    title.text = LocalizedString(@"setting", nil);
    title.textColor = colorWithHexString(@"#878787");
    title.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = title;
    
    UIButton *navBackItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kNavBarH, kNavBarH)];
    [navBackItem setImage:[UIImage imageNamed:@"fe_icon_no_normal"] forState:UIControlStateNormal];
    [navBackItem setImage:[UIImage imageNamed:@"fe_icon_no_pressed"] forState:UIControlStateHighlighted];
    [navBackItem addTarget:self action:@selector(leftBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    navBackItem.imageView.contentMode = UIViewContentModeCenter;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navBackItem];
    
    _titles = @[LocalizedString(@"picture_resolution", nil),
                LocalizedString(@"update", nil),
                LocalizedString(@"score", nil),
                LocalizedString(@"feedback", nil),
                LocalizedString(@"share_app", nil), ];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = colorWithHexString(@"#2f2f2f");
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [PRJ_Global event:@"setting_resolution" label:@"Setting"];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:LocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:LocalizedString(@"standard", nil),LocalizedString(@"HD", nil), nil];
        [actionSheet showInView:self.view];
    }
    else
    {
        switch (indexPath.row) {
            case 0:
            {
                [PRJ_Global event:@"setting_update" label:@"Setting"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreURL]];
                break;
            }
            case 1:
            {
                [PRJ_Global event:@"setting_rate" label:@"Setting"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreScoreURL]];
                
                //关闭评论提醒
                [[NSUserDefaults standardUserDefaults] setObject:@(-1) forKey:UDKEY_ShareCount];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            }
            case 2:
            {
                [PRJ_Global event:@"etting_feedback" label:@"Setting"];
                //发邮件
                NSString *deviceInfo = getDeviceInfo();
                MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                if(!picker) break;
                NSString *subject = [NSString stringWithFormat:@"FilterGrid %@ (iOS)",LocalizedString(@"feedback", nil)];
                [picker setSubject:subject];
                [picker setToRecipients:@[kFeedbackEmail]];
                [picker setMessageBody:deviceInfo isHTML:NO];
                [picker setMailComposeDelegate:self];
                [self presentViewController:picker animated:YES completion:nil];
                break;
            }
            case 3:
            {
                [PRJ_Global event:@"setting_share" label:@"Setting"];
                //分享
                NSArray *activityItems = @[LocalizedString(@"share_msg", nil)];
                UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                
                activityVC.completionHandler = ^(NSString *activityType,BOOL completed){
                    
                    UIView *banner = [PRJ_Global shareStance].bannerView;
                    [[UIApplication sharedApplication].keyWindow addSubview:banner];
                };
                [self presentViewController:activityVC animated:YES completion:nil];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RC_SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RC_SettingViewController"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RC_SettingCell" owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = colorWithHexString(@"#383838");
        cell.lblSubhead.textColor = colorWithHexString(@"#646262");
        cell.lblTitle.textColor = colorWithHexString(@"#878787");
        cell.line.backgroundColor = colorWithHexString(@"#252525");
    }
    
    if (indexPath.section == 0)
    {
        [cell.imgHead setImage:[UIImage imageNamed:@"fe_icon_picture quality"]];
        [cell.lblTitle setText:_titles[0]];
        [cell.lblSubhead setText:[[PRJ_Global shareStance] getCurrentOutputResolutionStr]];
        cell.line.hidden = YES;
    }
    else
    {
        [cell.imgHead setImage:[UIImage imageNamed:[NSString stringWithFormat:@"fe_icon_%ld",(long)indexPath.row]]];
        [cell.lblTitle setText:_titles[indexPath.row+1]];
        cell.line.hidden = NO;
        cell.lblSubhead.text = nil;
        if (indexPath.row == 0)
        {
            cell.lblSubhead.text = @"V1.0.0";
        }
        if (indexPath.row == _titles.count-2)
        {
            cell.line.hidden = YES;
        }
    }
    
    return cell;
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"alertView");
    
    switch (buttonIndex) {
        case kOutputResolutionType1080_1080:
            [PRJ_Global event:@"setting_resolution_normal" label:@"Setting"];
            
            break;
        case kOutputResolutionType1660_1660:
            [PRJ_Global event:@"setting_resolution_high" label:@"Setting"];
            break;
            
        default:
            break;
    }
    
    [PRJ_Global shareStance].outputResolutionType = (OutputResolutionType)buttonIndex;
    [_tableView reloadData];
    
    [[NSUserDefaults standardUserDefaults] setInteger:buttonIndex forKey:UDKEY_OutputResolutionType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    switch (buttonIndex) {
        case kOutputResolutionType1080_1080:
            [PRJ_Global event:@"setting_resolution_normal" label:@"Setting"];
            
            break;
        case kOutputResolutionType1660_1660:
            [PRJ_Global event:@"setting_resolution_high" label:@"Setting"];
            break;
            
        default:
            return;
    }
    
    [PRJ_Global shareStance].outputResolutionType = (OutputResolutionType)buttonIndex;
    [_tableView reloadData];
    
    [[NSUserDefaults standardUserDefaults] setInteger:buttonIndex forKey:UDKEY_OutputResolutionType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
