//
//  WPClockColumnView.h
//  WPHealth
//
//  Created by justone on 15/6/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPClockColumnView;

@protocol WPClockColumnViewDelegate <NSObject>

@optional
- (void)clockColumnView:(WPClockColumnView *)aClockColumnView didTapGestureRecognizerAtIndex:(NSInteger)aIndex;

- (void)clockColumnView:(WPClockColumnView *)aClockColumnView didSelectBtnAtIndex:(NSInteger)aIndex;

@end

@interface WPClockColumnView : UIView

@property (nonatomic, assign) id<WPClockColumnViewDelegate> delegate;

@property (nonatomic, strong) UIImageView *leftBgImageView;
@property (nonatomic, strong) UILabel *leftCountLabel;
@property (nonatomic, strong) UILabel *leftTimeLabel;
@property (nonatomic, strong) UIButton *leftContentBtn;

@property (nonatomic, strong) UIImageView *rightBgImageView;
@property (nonatomic, strong) UILabel *rightCountLabel;
@property (nonatomic, strong) UILabel *rightTimeLabel;
@property (nonatomic, strong) UIButton *rightContentBtn;

@end
