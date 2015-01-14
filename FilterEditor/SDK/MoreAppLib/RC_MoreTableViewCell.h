//
//  Me_MoreTableViewCell.h
//  IOSMirror
//
//  Created by gaoluyangrc on 14-6-20.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RC_AppInfo.h"

@interface RC_MoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *installLabel;
@property (strong ,nonatomic) RC_AppInfo *appInfo;

@property (strong ,nonatomic) NSLayoutConstraint *layoutconstraint;

- (IBAction)installBtnClick:(id)sender;

@end
