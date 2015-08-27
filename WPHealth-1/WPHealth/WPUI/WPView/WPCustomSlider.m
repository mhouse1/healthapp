//
//  WPCustomSlider.m
//  WPHealth
//
//  Created by justone on 15/6/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPCustomSlider.h"
#import "UIImage+WP.h"

#define IMAGE_HEIGHT    12.

@interface WPCustomSlider ()

@property (nonatomic, strong) UIImageView *leftBgImageView;
@property (nonatomic, strong) UIImageView *rightBgImageView;
@property (nonatomic, strong) UIImageView *maxImageView;
@property (nonatomic, strong) UILabel *maxCountLabel;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation WPCustomSlider

#pragma mark - custom Methods

- (UIImage *)tumbImageWithText:(NSString *)aText
{
    UIImage *tumbImage= [[UIImage imageNamed:@"tree_small_bg.png"] stretchableImageWithLeftCapWidth:30. topCapHeight:15.];
    
    UIGraphicsBeginImageContext(tumbImage.size);
    [tumbImage drawAtPoint: CGPointZero];
    
    CGFloat left_space = 11.;
    if ([aText integerValue] >= 10) {
        left_space = 8.;
    }
    
    [aText drawInRect:CGRectMake(left_space, 6.0, tumbImage.size.width, tumbImage.size.height)
       withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                        NSForegroundColorAttributeName: [UIColor whiteColor]
                        }];
    
    tumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tumbImage;
}

#pragma mark - buttonAction

- (void)handleSliderAction:(UISlider *)slider
{
    self.leftBgImageView.frame = CGRectMake(0., (self.bounds.size.height-IMAGE_HEIGHT)/2, self.bounds.size.width * (self.slider.value/26), IMAGE_HEIGHT);
    
    UIImage *tumbImage= [self tumbImageWithText:[NSString stringWithFormat:@"%@", @((int)self.slider.value)]];
    
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
    [self.slider setThumbImage:tumbImage forState:UIControlStateHighlighted];
    [self.slider setThumbImage:tumbImage forState:UIControlStateNormal];
}

#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        self.rightBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0., (self.bounds.size.height-IMAGE_HEIGHT)/2, self.bounds.size.width, IMAGE_HEIGHT)];
        self.rightBgImageView.image = [[UIImage imageNamed:@"slider_bg.png"] stretchableImageWithLeftCapWidth:30. topCapHeight:5.];
        self.rightBgImageView.userInteractionEnabled = YES;
        [self addSubview:self.rightBgImageView];
        
        self.leftBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0., (self.bounds.size.height-IMAGE_HEIGHT)/2, self.bounds.size.width, IMAGE_HEIGHT)];
        self.leftBgImageView.image = [[UIImage imageNamed:@"slider.png"] stretchableImageWithLeftCapWidth:30. topCapHeight:5.];
        self.leftBgImageView.userInteractionEnabled = YES;
        [self addSubview:self.leftBgImageView];
        
        self.maxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-32., (self.bounds.size.height-35.)/2, 35., 35.)];
        self.maxImageView.image = [[UIImage imageNamed:@"tree_big_bg.png"] stretchableImageWithLeftCapWidth:30. topCapHeight:5.];
        self.maxImageView.userInteractionEnabled = YES;
        [self addSubview:self.maxImageView];
        
        self.maxCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-32., (self.bounds.size.height-35.)/2, 35., 35.)];
        [self.maxCountLabel setFont:[UIFont boldSystemFontOfSize:16.]];
        self.maxCountLabel.textAlignment = NSTextAlignmentCenter;
        self.maxCountLabel.backgroundColor = [UIColor clearColor];
        self.maxCountLabel.textColor = [UIColor whiteColor];
        self.maxCountLabel.text = @"26";
        [self addSubview:self.maxCountLabel];

        self.slider = [[UISlider alloc] initWithFrame:self.bounds];
        
        UIImage *trackImage = createImageWithColor([UIColor clearColor], self.bounds.size);
        
        [self.slider setMinimumTrackImage:trackImage forState:UIControlStateNormal];
        [self.slider setMaximumTrackImage:trackImage forState:UIControlStateNormal];
        
        // 自定义滑块的图片
        UIImage *tumbImage= [self tumbImageWithText:@"5"];
        
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [self.slider setThumbImage:tumbImage forState:UIControlStateHighlighted];
        [self.slider setThumbImage:tumbImage forState:UIControlStateNormal];
        
        self.slider.minimumValue = 0.0;
        self.slider.maximumValue = 26.0;
        self.slider.continuous = YES;
        self.slider.value = 5;
        
        // 滑块拖动时的事件
        [self.slider addTarget:self action:@selector(handleSliderAction:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:self.slider];
        
        self.leftBgImageView.frame = CGRectMake(0., (self.bounds.size.height-IMAGE_HEIGHT)/2, self.bounds.size.width * (self.slider.value/26), IMAGE_HEIGHT);
    }
    return self;
}

@end
