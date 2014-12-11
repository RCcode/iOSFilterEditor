//
//  RC_SettingCell.h
//  FilterGrid
//
//  Created by TCH on 14-11-5.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RC_SettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubhead;
@property (weak, nonatomic) IBOutlet UIImageView *imgTail;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
