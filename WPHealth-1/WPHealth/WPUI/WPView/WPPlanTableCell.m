//
//  WPPlanTableCell.m
//  WPHealth
//
//  Created by justone on 15/5/27.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPPlanTableCell.h"

@implementation WPPlanTableCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        WEAKSELF(weakSelf);
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.iconImageView.userInteractionEnabled = NO;
        [self addSubview:self.iconImageView];
        [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.left).offset(30);
            make.centerY.equalTo(weakSelf.contentView.centerY);
            make.width.equalTo(40.);
            make.height.equalTo(40.);
        }];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:15.]];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.iconImageView.right).offset(15.);
            make.centerY.equalTo(weakSelf.contentView.centerY);
        }];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.timeLabel setFont:[UIFont boldSystemFontOfSize:12.]];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView.right).offset(-30);
            make.centerY.equalTo(weakSelf.contentView.centerY);
        }];

        UIImageView* bottomLineSepView = [[UIImageView alloc] initWithFrame:CGRectZero];
        bottomLineSepView.backgroundColor = [UIColor clearColor];
        //bottomLineSepView.image = [UIImage imageNamed:@"line.png"];
        [self.contentView addSubview:bottomLineSepView];
        [bottomLineSepView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(15.);
            make.bottom.equalTo(self.contentView.bottom);
            make.height.equalTo(1);
            make.right.equalTo(self.contentView.right);
        }];
    }
    return self;
}

+ (CGFloat)height
{
    return 50.;
}

@end
