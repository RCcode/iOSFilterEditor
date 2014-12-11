//
//  ImageEditFilterViewItem.h
//  FilterGrid
//
//  Created by herui on 16/9/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageEditFilterViewItem : UIButton

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UILabel *nameLabel;


@end
