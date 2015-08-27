//
//  WPDataViewController.m
//  WPHealth
//
//  Created by justone on 15-5-25.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPDataViewController.h"
#import "AMProgressView.h"

@interface WPDataViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;

@end

@implementation WPDataViewController

#pragma mark - loadView

- (void)createLeftView
{
    self.leftView = [[UIView alloc] initWithFrame:CGRectZero];
    self.leftView.backgroundColor = [UIColor colorWithRed:48./255. green:60./255. blue:85./255. alpha:1.];
    
    UILabel *coinLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [coinLabel setFont:[UIFont boldSystemFontOfSize:60.]];
    coinLabel.textAlignment = NSTextAlignmentCenter;
    coinLabel.backgroundColor = [UIColor clearColor];
    coinLabel.textColor = [UIColor colorWithRed:252./255. green:155./255. blue:51./255. alpha:1.0];
    coinLabel.text = @"264";
    [self.leftView addSubview:coinLabel];
    [coinLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.left);
        make.right.equalTo(self.leftView.right);
        make.centerY.equalTo(self.leftView.centerY);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16.]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"健康币总额";
    [self.leftView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.left);
        make.right.equalTo(self.leftView.right);
        make.bottom.equalTo(coinLabel.top);
    }];
    
    [self.view addSubview:self.leftView];
    [self.leftView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.bottom.equalTo(self.view.bottom);
        make.right.equalTo(self.view.centerX).offset(-3);
        make.height.equalTo(200.);
    }];
}

- (void)createRightView
{
    self.rightView = [[UIView alloc] initWithFrame:CGRectZero];
    self.rightView.backgroundColor = [UIColor colorWithRed:48./255. green:60./255. blue:85./255. alpha:1.];
    
    UILabel *coinLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [coinLabel setFont:[UIFont boldSystemFontOfSize:60.]];
    coinLabel.textAlignment = NSTextAlignmentCenter;
    coinLabel.backgroundColor = [UIColor clearColor];
    coinLabel.textColor = [UIColor colorWithRed:230./255. green:101./255. blue:105./255. alpha:1.0];
    coinLabel.text = @"28";
    [self.rightView addSubview:coinLabel];
    [coinLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightView.left);
        make.right.equalTo(self.rightView.right);
        make.centerY.equalTo(self.rightView.centerY);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16.]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"已打卡日";
    [self.rightView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightView.left);
        make.right.equalTo(self.rightView.right);
        make.bottom.equalTo(coinLabel.top);
    }];
    
    [self.view addSubview:self.rightView];
    [self.rightView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
        make.left.equalTo(self.view.centerX).offset(3);
        make.height.equalTo(200.);
    }];
}

- (void)createHeaderView
{
    self.headerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.headerView.backgroundColor = [UIColor colorWithRed:48./255. green:60./255. blue:85./255. alpha:1.];
    
    UILabel *coinLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [coinLabel setFont:[UIFont boldSystemFontOfSize:90.]];
    coinLabel.textAlignment = NSTextAlignmentCenter;
    coinLabel.backgroundColor = [UIColor clearColor];
    coinLabel.textColor = [UIColor colorWithRed:82./255. green:184./255. blue:170./255. alpha:1.0];
    coinLabel.text = @"675";
    [self.headerView addSubview:coinLabel];
    [coinLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.left);
        make.right.equalTo(self.headerView.right).offset(-100);
        make.centerY.equalTo(self.headerView.centerY);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"健康点指数";
    [self.headerView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.left);
        make.right.equalTo(self.headerView.right).offset(-100);
        make.bottom.equalTo(coinLabel.top);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [tipLabel setFont:[UIFont boldSystemFontOfSize:14.]];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.text = @"健康点等级：良好";
    [self.headerView addSubview:tipLabel];
    [tipLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.left);
        make.right.equalTo(self.headerView.right).offset(-100);
        make.top.equalTo(coinLabel.bottom);
    }];
    
    AMProgressView *progressView = [[AMProgressView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100+5, 40, 50., 170.)
                                                       andGradientColors:nil
                                                        andOutsideBorder:YES
                                                             andVertical:YES];
    progressView.progress = 1.0;
    [self.headerView addSubview:progressView];
    
    [self.view addSubview:self.headerView];
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.bottom.equalTo(self.leftView.top).offset(-6);
        make.left.right.equalTo(self.view);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:42./255. green:52./255. blue:71./255. alpha:1.];

    [self createLeftView];
    [self createRightView];
    [self createHeaderView];
}


@end
