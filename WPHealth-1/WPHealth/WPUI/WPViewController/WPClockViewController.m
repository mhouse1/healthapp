//
//  WPClockViewController.m
//  WPHealth
//
//  Created by justone on 15-5-25.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPClockViewController.h"
#import "WPPopClockCardBackView.h"
#import "WPPopClockStatusView.h"
#import "WPPopClockAddTagView.h"
#import "WPGetAllCardsCommand.h"
#import "WPClockColumnView.h"
#import "WPCustomSlider.h"
#import "GKUIColumnView.h"

#define WPClockColumnView_Tag      10000

@interface WPClockViewController ()<WPClockColumnViewDelegate,
GKUIColumnViewDelegate,
GKUIColumnViewDataSource,
UIScrollViewDelegate>

@property (nonatomic, strong) GKUIColumnView *columnView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) WPCustomSlider *customSlider;

@end

@implementation WPClockViewController

#pragma mark - loadData

- (void)loadData
{
    WPGetAllCardsCommand *getAllCardsCmd = [[WPGetAllCardsCommand alloc] init];
    
    [getAllCardsCmd postCommandWithSuccess:^(NSDictionary *aResponseDict) {
        NSLog(@"%@", aResponseDict);
    } failure:^(NSError *aError) {
        
    }];
}

#pragma mark - loadView

- (void)createHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor colorWithRed:48./255. green:60./255. blue:85./255. alpha:1.];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    iconImageView.backgroundColor = [UIColor clearColor];
    iconImageView.image = [UIImage imageNamed:@"icon.png"];
    iconImageView.userInteractionEnabled = NO;
    iconImageView.layer.cornerRadius = 75./2;
    iconImageView.layer.masksToBounds = YES;
    [headerView addSubview:iconImageView];
    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(75.);
        make.height.equalTo(75.);
        make.centerX.equalTo(headerView.centerX);
        make.top.equalTo(headerView.top).offset(25);
    }];
    
    [self.view addSubview:headerView];
    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(130.);
    }];
}

- (void)createSlider
{
    self.customSlider = [[WPCustomSlider alloc] initWithFrame:CGRectMake(30., 115., WPMAINSCREEN_SIZE.width-30.*2, 30.)];
    
    [self.view addSubview:self.customSlider];
}

- (void)createTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:15.]];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:76./255. green:174./255. blue:168./255. alpha:1.];
    titleLabel.text = @"今日健康币";
    [self.view addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(145.);
        make.left.equalTo(self.view).equalTo(30.);
        make.right.equalTo(self.view).equalTo(-30.);
    }];
}

- (void)createColumnView
{
    self.columnView = [[GKUIColumnView alloc] initWithFrame:CGRectZero];
    
    self.columnView.viewDataSource = self;
    self.columnView.viewDelegate = self;
    self.columnView.delegate = self;
    self.columnView.pageEnadle = YES;
    
    [self.view addSubview:self.columnView];
    [self.columnView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(130.);
        make.bottom.left.right.equalTo(self.view);
    }];
}

- (void)createPageControl
{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.numberOfPages = 9;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:35./255. green:44./255. blue:59./255. alpha:1.];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:83./255. green:184./255. blue:169./255. alpha:1.];
    
    [self.view addSubview:self.pageControl];
    [self.pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-30.);
        make.left.right.equalTo(self.view);
    }];
}

- (void)viewDidLoad
{
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"preferred language is %@",language);
    //"en" = english , "zh-Hans" = chinese
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:42./255. green:52./255. blue:71./255. alpha:1.];
    
    [self createHeaderView];
    [self createColumnView];
    
    [self createSlider];
    [self createTitleLabel];
    [self createPageControl];
    
    [self loadData];
}

#pragma mark - WPClockColumnViewDelegate

- (void)clockColumnView:(WPClockColumnView *)aClockColumnView didTapGestureRecognizerAtIndex:(NSInteger)aIndex
{
    NSLog(@"didTapGestureRecognizerAtIndex %@",  @(aIndex));
    
    if (aIndex == 0) {
        WPPopClockCardBackView *popClockCardBackView = [[WPPopClockCardBackView alloc] initWithImageName:@"breakfast_card_back.png" content:@"如何做\n七八点时分吃早餐\n新鲜碳水化合物、蛋白质和蔬果一样不能少\n安安静静坐着吃，不可匆忙和马虎\n\n为何做\n不做身体会变酸\n慢性病会找上门\n首当其冲是胃的病\n而晨起后没有能量补充的你的躯壳和皮囊\n从大脑到脚趾头\n一天都会好倦怠\n\n奖励\n按时完成可获得2枚健康币\n完成后可以添加备注"];
        
        [popClockCardBackView show];
    } else {
        WPPopClockAddTagView *popClockAddTagView = [[WPPopClockAddTagView alloc] initWithOldTag:@"今天的早餐：什么和什么"];
        popClockAddTagView.finishedBlock = ^(NSString *aTag) {
            NSLog(@"WPPopClockAddTagView aTag:%@", aTag);
        };
        
        [popClockAddTagView show];
    }
}

- (void)clockColumnView:(WPClockColumnView *)aClockColumnView didSelectBtnAtIndex:(NSInteger)aIndex
{
    NSLog(@"didSelectBtnAtIndex %@",  @(aIndex));
    
    WPPopClockStatusView *popClockStatusView = [[WPPopClockStatusView alloc] initWithPlanName:@"喝水" status:YES];
    
    [popClockStatusView show];
}

#pragma mark - GKUIColumnViewDelegate

- (void)columnView:(GKUIColumnView *)columnView didSelectColumnAtIndex:(NSUInteger)index
{
    
}

- (void)columnView:(GKUIColumnView *)columnView touchesEnded:(NSUInteger)index
{
    
}

- (CGFloat)columnView:(GKUIColumnView *)columnView widthForColumnAtIndex:(NSUInteger)index
{
    return columnView.frame.size.width;
}

#pragma mark - GKUIColumnViewDataSource

- (NSUInteger)numberOfColumnsInColumnView:(GKUIColumnView *)columnView
{
    return 9;
}

- (GKUIColumnViewCell *)columnView:(GKUIColumnView *)columnView viewForColumnAtIndex:(NSUInteger)index
{
    NSString *cellId = [NSString stringWithFormat:@"cell%@", @(index)];
    GKUIColumnViewCell *cell = [columnView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[GKUIColumnViewCell alloc] initWithReuseIdentifier:cellId];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.columnView.frame.size.width, self.columnView.frame.size.height)];
        contentView.backgroundColor = [UIColor clearColor];
        
        WPClockColumnView *clockColumnView = [[WPClockColumnView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.columnView.frame.size.width, self.columnView.frame.size.height)];
        clockColumnView.delegate = self;
        
        cell.contentView = clockColumnView;
    }

    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrolling");
    self.pageControl.currentPage = self.columnView.pageIndex;
}

@end
