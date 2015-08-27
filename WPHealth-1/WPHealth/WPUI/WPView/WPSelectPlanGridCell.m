//
//  WPSelectPlanGridCell.m
//  WPHealth
//
//  Created by justone on 15/5/28.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPSelectPlanGridCell.h"

@interface WPSelectPlanGridCell ()

@property (nonatomic, strong) UIImageView *shadowImageView;

@end

@implementation WPSelectPlanGridCell

#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        self.contentBtn = [[UIButton alloc] initWithFrame:self.bounds];
        self.contentBtn.userInteractionEnabled = NO;
        self.contentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.];
        [self.contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentBtn setTitleEdgeInsets:UIEdgeInsetsMake(40, -46., 0, 0)];
        [self.contentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 20, 0)];
        
        [self addSubview:self.contentBtn];
        
        self.shadowImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.shadowImageView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        self.shadowImageView.userInteractionEnabled = YES;
        self.shadowImageView.hidden = YES;
        
        [self addSubview:self.shadowImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)aSelected
{
    self.shadowImageView.hidden = !aSelected;
}

@end
