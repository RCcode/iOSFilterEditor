//
//  Me_MoreTableViewCell.h
//  IOSMirror
//
//  Created by gaoluyangrc on 14-6-20.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ME_AppInfo.h"
#import "DBImageView.h"

@protocol MoreAppDelegate <NSObject>

- (void)jumpAppStore:(NSString *)appid;

@end

@interface Me_MoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet DBImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *installBtn;
@property (strong ,nonatomic) ME_AppInfo *appInfo;
@property (weak, nonatomic) id <MoreAppDelegate> delegate;

- (IBAction)installBtnClick:(id)sender;

@end
