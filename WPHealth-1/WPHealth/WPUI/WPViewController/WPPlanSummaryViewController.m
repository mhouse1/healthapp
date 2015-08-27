//
//  WPPlanSummaryViewController.m
//  WPHealth
//
//  Created by justone on 15/5/28.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPPlanSummaryViewController.h"
#import "TTTAttributedLabel.h"

@interface WPPlanSummaryViewController ()

@property (nonatomic, strong) TTTAttributedLabel *contentLabel;

@end

@implementation WPPlanSummaryViewController

#pragma mark - buttonAction

- (void)handleLastBtnEvent
{
    if (self.lastBtnBlock) {
        self.lastBtnBlock();
    }
}

- (void)handleNextBtnEvent
{
    if (self.nextBtnBlock) {
        self.nextBtnBlock();
    }
}

#pragma mark - loaView

- (void)createSubViews
{
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    iconImageView.userInteractionEnabled = NO;
    iconImageView.image = [UIImage imageNamed:self.contentPlan.iconNameColor];
    [self.view addSubview:iconImageView];
    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(15);
        make.top.equalTo(self.view.top).offset(10);
        make.width.equalTo(40.);
        make.height.equalTo(40.);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:15.]];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = self.contentPlan.planName;
    [self.view addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.right);
        make.right.equalTo(self.view.right).offset(-15);
        make.centerY.equalTo(iconImageView.centerY);
    }];
    
    UIButton *lastBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [lastBtn setBackgroundImage:[UIImage imageNamed:@"last_step_btn.png"] forState:UIControlStateNormal];
    [lastBtn addTarget:self action:@selector(handleLastBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:lastBtn];
    [lastBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(118);
        make.height.equalTo(40);
        make.right.equalTo(self.view.centerX).offset(-10);
        make.bottom.equalTo(self.view.bottom).offset(-30);
    }];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"next_step_btn.png"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(handleNextBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nextBtn];
    [nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(116);
        make.height.equalTo(38);
        make.left.equalTo(self.view.centerX).offset(10);
        make.centerY.equalTo(lastBtn.centerY);
    }];
    
    self.contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    [self.contentLabel setFont:[UIFont boldSystemFontOfSize:13.]];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.numberOfLines = 0;
    
    NSString *str = [self.contentPlan.summary stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\r\n"];
    [self.contentLabel setText:str afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange firstRange = [[mutableAttributedString string] rangeOfString:@"如何做" options:NSCaseInsensitiveSearch];
        NSRange secondRange = [[mutableAttributedString string] rangeOfString:@"为何做" options:NSCaseInsensitiveSearch];
        NSRange thirdRange = [[mutableAttributedString string] rangeOfString:@"奖励" options:NSCaseInsensitiveSearch];
        
        UIColor *color = [UIColor colorWithRed:76./255. green:174./255. blue:168./255. alpha:1.];
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:color range:firstRange];
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:color range:secondRange];
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:color range:thirdRange];
        
        return mutableAttributedString;
    }];
    
    [self.view addSubview:self.contentLabel];
    [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(15);
        make.right.equalTo(self.view.right).offset(-15);
        make.top.equalTo(iconImageView.bottom).offset(10);
        make.bottom.equalTo(lastBtn.top).offset(-10);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSubViews];
}

- (void)reloadData
{
    
}

@end
