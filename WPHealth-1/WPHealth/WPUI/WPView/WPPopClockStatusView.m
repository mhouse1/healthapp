//
//  WPPopClockStatusView.m
//  WPHealth
//
//  Created by justone on 15/6/2.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPPopClockStatusView.h"

#define IMAGE_WIDTH     251.
#define IMAGE_HEIGHT    251.

@interface WPPopClockStatusView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *popImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *contentBtn;

@end

@implementation WPPopClockStatusView

#pragma mark - buttonAction

- (void)handleContentBtnEvent:(UIButton *)aBtn
{
    [self dismiss];
}

#pragma mark - GestureRecognizer

- (void)handletap
{
    [self dismiss];
}

#pragma mark - init

- (void)createGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletap)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (id)initWithPlanName:(NSString *)aPlanName status:(BOOL)aStatus
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, WPMAINSCREEN_SIZE.width, WPMAINSCREEN_SIZE.height)];
    if ( self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.popImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-IMAGE_WIDTH)/2, (self.bounds.size.height-IMAGE_HEIGHT)/2, IMAGE_WIDTH, IMAGE_HEIGHT)];
        self.popImageView.image = [[UIImage imageNamed:@"clock_success_bg.png"] stretchableImageWithLeftCapWidth:30. topCapHeight:30.];
        self.popImageView.userInteractionEnabled = YES;
        [self addSubview:self.popImageView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.popImageView.frame.origin.x+(self.popImageView.frame.size.width/2-50./2), self.popImageView.frame.origin.y+30, 50., 50.)];
        self.iconImageView.userInteractionEnabled = YES;
        [self addSubview:self.iconImageView];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.popImageView.frame.origin.x+30., self.iconImageView.frame.origin.y+self.iconImageView.frame.size.height+10., self.popImageView.frame.size.width-30.*2, 90.)];
        [self.contentLabel setFont:[UIFont boldSystemFontOfSize:13.]];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.numberOfLines = 0;
        [self addSubview:self.contentLabel];
        
        self.contentBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.popImageView.frame.origin.x+(self.popImageView.frame.size.width/2-116./2), self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+10., 116, 38.)];
        [self.contentBtn setBackgroundImage:[UIImage imageNamed:@"know_btn_normal.png"] forState:UIControlStateNormal];
        [self.contentBtn addTarget:self action:@selector(handleContentBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.contentBtn];
        
        [self createGestureRecognizer];
        
        if (aStatus == YES) {
            self.iconImageView.image = [UIImage imageNamed:@"clock_success_icon.png"];
            self.contentLabel.text = [NSString stringWithFormat:@"恭喜你 %@ 打卡成功\n获得2枚健康币\n继续加油", aPlanName];
        } else {
            self.iconImageView.image = [UIImage imageNamed:@"clock_failed_icon.png"];
            self.contentLabel.text = [NSString stringWithFormat:@"恭喜你 %@ 打卡失败\n明天加油", aPlanName];
        }
    }
    return self;
}

- (void)show
{
    self.alpha = 0.0;
    [APP_DELEGATE.window addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = [touch view];
    if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UILabel class]]) {
        return NO;
    }
    return YES;
}

@end
