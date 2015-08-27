//
//  WPClockColumnView.m
//  WPHealth
//
//  Created by justone on 15/6/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPClockColumnView.h"

#define IMAGE_WIDTH     120.
#define IMAGE_HEIGHT    180.

@interface WPClockColumnView ()<UIGestureRecognizerDelegate>

@end

@implementation WPClockColumnView

#pragma mark - buttonAction

- (void)handleContentBtnEvent:(UIButton *)aBtn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clockColumnView:didSelectBtnAtIndex:)]) {
        [self.delegate clockColumnView:self didSelectBtnAtIndex:aBtn.tag];
    }
}

#pragma mark - tap

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint locationTouch = [gestureRecognizer locationInView:self];
    BOOL isTouchLeftView = locationTouch.x > WPMAINSCREEN_SIZE.width/2 ? NO:YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clockColumnView:didTapGestureRecognizerAtIndex:)]) {
        [self.delegate clockColumnView:self didTapGestureRecognizerAtIndex:isTouchLeftView];
    }
}

#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        WEAKSELF(weakSelf);
        
        CGFloat image_spacing = (WPMAINSCREEN_SIZE.width-IMAGE_WIDTH*2)/3;
        
        self.leftBgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.leftBgImageView.image = [UIImage imageNamed:@"run_card_before.png"];
        self.leftBgImageView.userInteractionEnabled = YES;
        [self addSubview:self.leftBgImageView];
        [self.leftBgImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.top).offset(60.);
            make.right.equalTo(weakSelf.centerX).offset(-image_spacing/2);
            make.width.equalTo(IMAGE_WIDTH);
            make.height.equalTo(IMAGE_HEIGHT);
        }];
        
        self.leftCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.leftCountLabel setFont:[UIFont boldSystemFontOfSize:12.]];
        self.leftCountLabel.textAlignment = NSTextAlignmentCenter;
        self.leftCountLabel.backgroundColor = [UIColor clearColor];
        self.leftCountLabel.textColor = [UIColor blackColor];
        self.leftCountLabel.text = @"5";
        [self addSubview:self.leftCountLabel];
        [self.leftCountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.leftBgImageView.top).offset(13.);
            make.right.equalTo(weakSelf.leftBgImageView.right).offset(-7.);
            make.width.equalTo(28.);
        }];
        
        self.leftContentBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        self.leftContentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.];
        [self.leftContentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftContentBtn setTitle:@"立即打卡" forState:UIControlStateNormal];
        [self.leftContentBtn addTarget:self action:@selector(handleContentBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.leftContentBtn];
        [self.leftContentBtn makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.leftBgImageView.bottom);
            make.left.equalTo(weakSelf.leftBgImageView.left);
            make.right.equalTo(weakSelf.leftBgImageView.right);
            make.height.equalTo(40.);
        }];
        
        self.rightTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.rightTimeLabel setFont:[UIFont boldSystemFontOfSize:15.]];
        self.rightTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.rightTimeLabel.backgroundColor = [UIColor clearColor];
        self.rightTimeLabel.textColor = [UIColor whiteColor];
        self.rightTimeLabel.text = @"07:00";
        [self addSubview:self.rightTimeLabel];
        [self.rightTimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.leftContentBtn.top).offset(-5.);
            make.left.equalTo(weakSelf.leftBgImageView.left);
            make.right.equalTo(weakSelf.leftBgImageView.right);
            make.height.equalTo(30.);
        }];
        
        self.rightBgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.rightBgImageView.image = [UIImage imageNamed:@"climbStairs_card_before.png"];
        self.rightBgImageView.userInteractionEnabled = YES;
        [self addSubview:self.rightBgImageView];
        [self.rightBgImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.top).offset(60.);
            make.left.equalTo(weakSelf.centerX).offset(image_spacing/2);
            make.width.equalTo(IMAGE_WIDTH);
            make.height.equalTo(IMAGE_HEIGHT);
        }];
        
        self.rightCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.rightCountLabel setFont:[UIFont boldSystemFontOfSize:12.]];
        self.rightCountLabel.textAlignment = NSTextAlignmentCenter;
        self.rightCountLabel.backgroundColor = [UIColor clearColor];
        self.rightCountLabel.textColor = [UIColor blackColor];
        self.rightCountLabel.text = @"9";
        [self addSubview:self.rightCountLabel];
        [self.rightCountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.rightBgImageView.top).offset(13.);
            make.right.equalTo(weakSelf.rightBgImageView.right).offset(-7.);
            make.width.equalTo(28.);
        }];

        self.rightContentBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        self.rightContentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.];
        [self.rightContentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.rightContentBtn setTitle:@"立即打卡" forState:UIControlStateNormal];
        [self.rightContentBtn addTarget:self action:@selector(handleContentBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightContentBtn];
        [self.rightContentBtn makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.rightBgImageView.bottom);
            make.left.equalTo(weakSelf.rightBgImageView.left);
            make.right.equalTo(weakSelf.rightBgImageView.right);
            make.height.equalTo(40.);
        }];
        
        self.rightTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.rightTimeLabel setFont:[UIFont boldSystemFontOfSize:15.]];
        self.rightTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.rightTimeLabel.backgroundColor = [UIColor clearColor];
        self.rightTimeLabel.textColor = [UIColor whiteColor];
        self.rightTimeLabel.text = @"09:00";
        [self addSubview:self.rightTimeLabel];
        [self.rightTimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.rightContentBtn.top).offset(-5.);
            make.left.equalTo(weakSelf.rightBgImageView.left);
            make.right.equalTo(weakSelf.rightBgImageView.right);
            make.height.equalTo(30.);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleTapGestureRecognizer:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = [touch view];
    if ([view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

@end
