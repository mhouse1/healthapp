//
//  WPPopClockCardBackView.m
//  WPHealth
//
//  Created by justone on 15/6/2.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPPopClockCardBackView.h"
#import "TTTAttributedLabel.h"

#define IMAGE_WIDTH     250.
#define IMAGE_HEIGHT    398.

@interface WPPopClockCardBackView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *popImageView;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;

@end

@implementation WPPopClockCardBackView

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

- (id)initWithImageName:(NSString *)aImageName content:(NSString *)aContent
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, WPMAINSCREEN_SIZE.width, WPMAINSCREEN_SIZE.height)];
    if ( self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.popImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-IMAGE_WIDTH)/2, (self.bounds.size.height-IMAGE_HEIGHT)/2, IMAGE_WIDTH, IMAGE_HEIGHT)];
        self.popImageView.image = [[UIImage imageNamed:aImageName] stretchableImageWithLeftCapWidth:30. topCapHeight:70.];
        self.popImageView.userInteractionEnabled = YES;
        [self addSubview:self.popImageView];
        
        self.contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(self.popImageView.frame.origin.x+30., self.popImageView.frame.origin.y+70., self.popImageView.frame.size.width-30.*2, self.popImageView.frame.size.height-70.-10.)];
        [self.contentLabel setFont:[UIFont boldSystemFontOfSize:13.]];
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.numberOfLines = 0;
        
        [self.contentLabel setText:aContent afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            //how to do
            NSRange firstRange = [[mutableAttributedString string] rangeOfString:@"如何做" options:NSCaseInsensitiveSearch];
            //why do
            NSRange secondRange = [[mutableAttributedString string] rangeOfString:@"为何做" options:NSCaseInsensitiveSearch];
            //reward
            NSRange thirdRange = [[mutableAttributedString string] rangeOfString:@"奖励" options:NSCaseInsensitiveSearch];
            
            UIColor *color = [UIColor colorWithRed:76./255. green:174./255. blue:168./255. alpha:1.];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:color range:firstRange];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:color range:secondRange];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:color range:thirdRange];
            
            return mutableAttributedString;
        }];
        
        [self addSubview:self.contentLabel];
        
        [self createGestureRecognizer];
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
    if ([view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UILabel class]]) {
        return NO;
    }
    return YES;
}

@end
