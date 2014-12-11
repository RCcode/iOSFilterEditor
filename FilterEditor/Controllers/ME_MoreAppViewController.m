//
//  ME_MoreAppViewController.m
//  IOSMirror
//
//  Created by gaoluyangrc on 14-7-14.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "ME_MoreAppViewController.h"
#import "CMethods.h"
#import "Me_MoreTableViewCell.h"
#import "ME_AppInfo.h"
#import "PRJ_Global.h"
#import <StoreKit/StoreKit.h>
#import "PRJ_SQLiteMassager.h"
#import "ME_AppInfo.h"
#import "IS_RequestManager.h"

@interface ME_MoreAppViewController () <UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate,MoreAppDelegate>
{
    UITableView *appInfoTableView;
    
    NSMutableArray *sourceArray;
    NSTimer *_timer;
}
@end

@implementation ME_MoreAppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    appInfoTableView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateState];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateState) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}
              
- (void)updateState
{
    [sourceArray removeAllObjects];
    NSMutableArray *un_down_datasource = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *have_down_datasource = [NSMutableArray arrayWithCapacity:0];
    for (ME_AppInfo *appInfo in [PRJ_Global shareStance].appsArray)
    {
        NSURL *url = [NSURL URLWithString:appInfo.openUrl];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [have_down_datasource addObject:appInfo];
        }
        else
        {
            [un_down_datasource addObject:appInfo];
        }
    }
    
    [sourceArray addObjectsFromArray:un_down_datasource];
    [sourceArray addObjectsFromArray:have_down_datasource];
    
    [appInfoTableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self
                                              selector:@selector(reloadDataForCollectionView)
                                                  name:UIApplicationWillEnterForegroundNotification
                                                object:nil];
    sourceArray = [[NSMutableArray alloc]initWithCapacity:0];
    CGFloat itemWH = 44;
    UIButton *navBackItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemWH, itemWH)];
    [navBackItem setImage:[UIImage imageNamed:@"fg_btn_x_normal"] forState:UIControlStateNormal];
    [navBackItem setImage:[UIImage imageNamed:@"fg_btn_x_pressed"] forState:UIControlStateHighlighted];
    [navBackItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    navBackItem.imageView.contentMode = UIViewContentModeCenter;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navBackItem];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    titleLabel.text = @"More Apps";
    titleLabel.font = [UIFont fontWithName:@"Raleway-Thin" size:24];
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    appInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44) style:UITableViewStylePlain];
    [appInfoTableView registerNib:[UINib nibWithNibName:@"Me_MoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    appInfoTableView.delegate = self;
    appInfoTableView.dataSource = self;
    appInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:appInfoTableView];
    
    //判断是否已下载完数据
    if ([PRJ_Global shareStance].appsArray.count == 0)
    {
        //查看数据库中是否存在
        if ([[PRJ_SQLiteMassager shareStance] getAllAppsInfoData].count == 0)
        {
            //Bundle Id

            __weak ME_MoreAppViewController *moreApp = self;
            
            [[IS_RequestManager shareInstance]getMoreAppSuccess:^(id responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    [moreApp didReceivedData:responseObject];
                }
            } andFailed:^(NSError *error) {
                
            }];
        }
        else
        {
            [PRJ_Global shareStance].appsArray = [[PRJ_SQLiteMassager shareStance] getAllAppsInfoData];
            [self updateState];
        }
    }

}

- (void)reloadDataForCollectionView
{
    [self updateState];
}

- (void)leftItemClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeMoreImage" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightItemClick
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Me_MoreTableViewCell *cell = (Me_MoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    
    ME_AppInfo *appInfo = [sourceArray objectAtIndex:indexPath.row];
    
    CGSize appNameSize = sizeWithContentAndFont(appInfo.appName, CGSizeMake(150, 80), 14);
    [cell.titleLabel setFrame:CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, appNameSize.width, appNameSize.height)];
    cell.titleLabel.text = appInfo.appName;
    cell.typeLabel.text = appInfo.appCate;
    [cell.logoImageView setImageWithPath:appInfo.iconUrl];
    cell.commentLabel.text = [NSString stringWithFormat:@"(%d)",appInfo.appComment];
    NSString *title = @"";
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appInfo.openUrl]])
    {
        title = LocalizedString(@"open", @"");
    }
    else
    {
        if ([appInfo.price isEqualToString:@"0"])
        {
            title = LocalizedString(@"free", @"");
        }
        else
        {
            title = appInfo.price;
        }
    }
    
    CGSize size = sizeWithContentAndFont(title, CGSizeMake(120, 26), 18);
    [cell.installBtn setFrame:CGRectMake(320 - size.width - 20, cell.installBtn.frame.origin.y, size.width, 26)];
    [cell.installBtn setTitle:title forState:UIControlStateNormal];
    
    cell.appInfo = appInfo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ME_AppInfo *appInfo = [sourceArray objectAtIndex:indexPath.row];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appInfo.openUrl]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appInfo.openUrl]];
    }
    else
    {
        [self jumpAppStore:appInfo.downUrl];
    }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)jumpAppStore:(NSString *)appid
{
    NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appid];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
}

#pragma mark -

- (void)didReceivedData:(NSDictionary *)dic
{
    NSArray *infoArray = [dic objectForKey:@"list"];
    NSMutableArray *datasoure_array = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary *infoDic in infoArray)
    {
        ME_AppInfo *appInfo = [[ME_AppInfo alloc] initWithDictionary:infoDic];
        [datasoure_array addObject:appInfo];
    }
    
    //判断是否有新应用
    if (datasoure_array.count > 0) {
        NSMutableArray *dataArray = [[PRJ_SQLiteMassager shareStance] getAllAppsInfoData];
        
        for (ME_AppInfo *app in datasoure_array)
        {
            BOOL isHave = NO;
            for (ME_AppInfo *appInfo in dataArray)
            {
                if (app.appId == appInfo.appId)
                {
                    isHave = YES;
                }
            }
            if (!isHave)
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"MoreAPP"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addMoreImage" object:nil];
                break;
            }
        }
        
        [[PRJ_SQLiteMassager shareStance] getAllAppsInfoData];
        [[PRJ_SQLiteMassager shareStance] insertAppInfo:datasoure_array];
        NSMutableArray *datasource_array = [[PRJ_SQLiteMassager shareStance] getAllAppsInfoData];
        [PRJ_Global shareStance].appsArray = datasource_array;
        [self updateState];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
