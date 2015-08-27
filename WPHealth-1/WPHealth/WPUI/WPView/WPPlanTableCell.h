//
//  WPPlanTableCell.h
//  WPHealth
//
//  Created by justone on 15/5/27.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPPlanTableCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

+ (CGFloat)height;

@end
