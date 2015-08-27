//
//  WPBaseViewController.m
//  WPHealthBank
//
//  Created by justone on 14-8-24.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPBaseViewController.h"
#import "MKInfoPanel.h"

@interface WPBaseViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, assign) NSInteger backItemType; // 1:back 2:title

@end

@implementation WPBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.needHideBack = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    __weak id <UIGestureRecognizerDelegate> weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    
    UIImage *stretchedImage = [[UIImage imageNamed:@"nav_bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.navigationController.navigationBar setBackgroundImage:stretchedImage
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18], NSFontAttributeName,nil];
    
    self.view.backgroundColor = [UIColor whiteColor];//[WPBaseColours colorFromHex:@"#E6E6E6"];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)setBackItem
{
    if (self.needHideBack) {
        return;
    }
    if (self.backItemType != 1) {
        self.backItemType = 1;
        
        self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., 23., 23.)];
        [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.backButton setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    }
}

- (void)setTitleBackItem
{
    if (self.needHideBack) {
        return;
    }
    if (self.backItemType != 2) {
        self.backItemType = 2;
        
        self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., 23., 23.)];
        [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.backButton setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    }
}

- (void)back
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    [self checkMemoryLeak];
}

- (void)showText:(NSString *)aText
{
    [MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeInfo
                           title:aText
                        subtitle:nil
                       hideAfter:1];
}

- (void)showTextInView:(UIView *)aParentView
                  text:(NSString *)aText
             hideAfter:(NSInteger)aInterval
{
    [MKInfoPanel showPanelInView:aParentView
                            type:MKInfoPanelTypeInfo
                           title:aText
                        subtitle:nil
                       hideAfter:aInterval];
}

- (NSString *)key
{
    return [self description];
}

- (BOOL)checkSameCanGoBack:(NSString *)aKey
{
    __block UIViewController* vc = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj != self) {
            if ([obj isKindOfClass:[WPBaseViewController class]]) {
                if ([[(WPBaseViewController *)obj key] isEqualToString:aKey]) {
                    vc = obj;
                    *stop = YES;
                }
            }
        }
    }];
    
    if (vc) {
        [self.navigationController popToViewController:vc animated:YES];
        return YES;
    }
    return NO;
}

- (void)checkMemoryLeak
{
#ifdef DEBUG
    __weak WPBaseViewController* weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSAssert(weakself != nil, @"内存泄露, %@", [weakself class]);
    });
#endif
}

- (void)reloadData
{
    
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
