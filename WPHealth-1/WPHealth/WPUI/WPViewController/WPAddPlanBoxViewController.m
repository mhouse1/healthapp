//
//  WPAddPlanBoxViewController.m
//  WPHealth
//
//  Created by justone on 15/5/28.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPAddPlanBoxViewController.h"
#import "WPPlanSummaryViewController.h"
#import "WPPlanSettingViewController.h"
#import "WPSelectPlanViewController.h"

typedef NS_ENUM(NSInteger, ActContentVCType) {
    ActContentVCTypeSelectPlan = 0, //选择计划
    ActContentVCTypePlanSummary,    //计划简介
    ActContentVCTypePlanSetting,    //计划设置
};

@interface WPAddPlanBoxViewController () <UIPageViewControllerDataSource,
UIPageViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, strong) NSMutableDictionary *contentVCDict;
@property (nonatomic, assign) NSInteger selectedTabIndex;

@property (nonatomic, strong) WPContentPlan* selectedContentPlan;

@end

@implementation WPAddPlanBoxViewController

#pragma mark - custom Methods

- (void)scrollToPageViewController:(ActContentVCType)aSelectedTabIndex
{
    WPBaseViewController* vc = (WPBaseViewController*)[self.pageViewController.viewControllers objectAtIndex:0];
    if (vc == nil || vc.view.tag != aSelectedTabIndex) {
        vc = [self viewControllerAtSelectedTabIndex:aSelectedTabIndex];
        NSArray* viewControllers = [NSArray arrayWithObject:vc];
        [self.pageViewController setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
    }
    
    self.selectedTabIndex = vc.view.tag;
    
    [self.scrollView scrollRectToVisible:CGRectMake(WPMAINSCREEN_SIZE.width*self.selectedTabIndex, 0.0, WPMAINSCREEN_SIZE.width, [self scrollViewHeight]) animated:YES];
}

- (WPBaseViewController*)viewControllerAtSelectedTabIndex:(NSInteger)aSelectedTabIndex
{
    if (aSelectedTabIndex == -1 || aSelectedTabIndex >= 3) {
        return nil;
    }
    
    WPBaseViewController* vc = [self.contentVCDict valueForKey:[NSString stringWithFormat:@"%@", @(aSelectedTabIndex)]];
    if (vc == nil) {
        WEAKSELF(weakSelf);
        
        if (aSelectedTabIndex == ActContentVCTypeSelectPlan) {
            WPSelectPlanViewController *selectPlanVC = [[WPSelectPlanViewController alloc] init];
            selectPlanVC.finishedBlock = ^(WPContentPlan* aContentPlan){
                weakSelf.selectedContentPlan = aContentPlan;
                [weakSelf scrollToPageViewController:ActContentVCTypePlanSummary];
            };
            
            vc = selectPlanVC;
        } else if (aSelectedTabIndex == ActContentVCTypePlanSummary) {
            WPPlanSummaryViewController *planSummaryVC = [[WPPlanSummaryViewController alloc] init];
            planSummaryVC.contentPlan = self.selectedContentPlan;
            planSummaryVC.lastBtnBlock = ^{
                [weakSelf scrollToPageViewController:ActContentVCTypeSelectPlan];
            };
            planSummaryVC.nextBtnBlock = ^{
                [weakSelf scrollToPageViewController:ActContentVCTypePlanSetting];
            };
            
            vc = planSummaryVC;
        } else if (aSelectedTabIndex == ActContentVCTypePlanSetting) {
            WPPlanSettingViewController *planSettingVC = [[WPPlanSettingViewController alloc] init];
            planSettingVC.contentPlan = self.selectedContentPlan;
            planSettingVC.lastBtnBlock = ^{
                [weakSelf scrollToPageViewController:ActContentVCTypePlanSummary];
            };
            planSettingVC.finishBtnBlock = ^(WPContentPlan* aContentPlan){
                
                [[[WPContentService shared] contentPlanModel] addSelectedContentPlan:aContentPlan];
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            
            vc = planSettingVC;
        }
        [self.contentVCDict setValue:vc forKey:[NSString stringWithFormat:@"%@", @(aSelectedTabIndex)]];
    }
    vc.view.tag = aSelectedTabIndex;
    vc.parentVC = self;
    [vc reloadData];
    return vc;
}

- (CGFloat)scrollViewHeight
{
    CGFloat height = 106.;
    if (WPMAINSCREEN_SIZE.width > 320.) {
        height = WPMAINSCREEN_SIZE.width*(106./320.);
    }
    return height;
}

- (void)loadScrollViewData
{
    for (NSInteger index = 0; index < 3; ++index) {

        UIImageView *contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width*index, 0.0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        contentImageView.backgroundColor = [UIColor clearColor];
        
        if (index == 0) {
            contentImageView.image = [UIImage imageNamed:@"select_plan_top.png"];
        } else if (index == 1) {
            contentImageView.image = [UIImage imageNamed:@"plan_summary_top.png"];
        } else if (index == 2) {
            contentImageView.image = [UIImage imageNamed:@"plan_setting_top.png"];
        }
        
        [self.scrollView addSubview:contentImageView];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*3, self.scrollView.frame.size.height);
}

#pragma mark - loaView

- (void)createScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0,
                                                                     0.0,
                                                                     WPMAINSCREEN_SIZE.width,
                                                                     [self scrollViewHeight])];
    
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.scrollView];
}

- (void)createPageViewController
{
    NSDictionary* options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    WPBaseViewController* vc = [self viewControllerAtSelectedTabIndex:self.selectedTabIndex];
    
    NSArray* viewControllers = [NSArray arrayWithObject:vc];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
    UIView* view = [self.pageViewController view];
    [self.view addSubview:view];
    [view makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo([self scrollViewHeight]);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackItem];
    self.title = @"新增计划";
    
    self.contentVCDict = [[NSMutableDictionary alloc] init];
    self.selectedTabIndex = 0;
    
    [self createScrollView];
    [self createPageViewController];
    
    [self loadScrollViewData];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerBeforeViewController:(UIViewController*)viewController
{
    return nil;//[self viewControllerAtSelectedTabIndex:self.selectedTabIndex-1];
}

- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerAfterViewController:(UIViewController*)viewController
{
    return nil;//[self viewControllerAtSelectedTabIndex:self.selectedTabIndex+1];
}

- (void)pageViewController:(UIPageViewController*)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray*)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        WPBaseViewController* vc = [self.pageViewController.viewControllers objectAtIndex:0];
        
        self.selectedTabIndex = vc.view.tag;
        
        [self.scrollView scrollRectToVisible:CGRectMake(WPMAINSCREEN_SIZE.width*self.selectedTabIndex, 0.0, WPMAINSCREEN_SIZE.width, [self scrollViewHeight]) animated:YES];
    }
}

@end
