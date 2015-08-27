//
//  AppDelegate.m
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "AppDelegate.h"
#import "WPLoginViewController.h"
#import "WPClockViewController.h"
#import "WPMoreViewController.h"
#import "WPDataViewController.h"
#import "WPPlanViewController.h"
#import "MKInfoPanel.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@property (nonatomic, strong) WPBaseTabBarController *rootTabBarViewController;

@end

@implementation AppDelegate

- (void)setRootTabBarController
{
    WPPlanViewController* planVC = [[WPPlanViewController alloc] init];
    planVC.title = @"计划";
    WPBaseNavigationController* planNavigationController = [[WPBaseNavigationController alloc] initWithRootViewController:planVC];
    planNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"tab_plan_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_plan_hl.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    WPClockViewController* clockVC = [[WPClockViewController alloc] init];
    clockVC.title = @"打卡";
    WPBaseNavigationController* clockNavigationController = [[WPBaseNavigationController alloc] initWithRootViewController:clockVC];
    clockNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"tab_clock_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_clock_hl.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    WPDataViewController* dataVC = [[WPDataViewController alloc] init];
    dataVC.title = @"数据";
    WPBaseNavigationController* dataNavigationController = [[WPBaseNavigationController alloc] initWithRootViewController:dataVC];
    dataNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"tab_data_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_data_hl.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    WPMoreViewController* moreVC = [[WPMoreViewController alloc] init];
    moreVC.title = @"更多";
    WPBaseNavigationController* moreNavigationController = [[WPBaseNavigationController alloc] initWithRootViewController:moreVC];
    moreNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"tab_more_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_more_hl.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    NSArray *navArray = [NSArray arrayWithObjects:planNavigationController, clockNavigationController, dataNavigationController, moreNavigationController, nil];
    
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    
    self.rootTabBarViewController = [[WPBaseTabBarController alloc] init];
    self.rootTabBarViewController.viewControllers = navArray;
    self.rootTabBarViewController.delegate = self;
    
    self.window.rootViewController = self.rootTabBarViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if ([[[WPContentService shared] contentCurrentUser].user_id length] > 0 || [[[WPContentService shared] contentCurrentUser].user_name length] > 0) {
        [self setRootTabBarController];
    } else {
        WPLoginViewController *loginVC = [[WPLoginViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    }

    [self.window makeKeyAndVisible];
    
#ifdef __IPHONE_8_0 //这里主要是针对iOS 8.0,相应的8.1,8.2等版本各程序员可自行发挥，如果苹果以后推出更高版本还不会使用这个注册方式就不得而知了……
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#endif
    
    NSLog(@"return from launch window");
    return YES;
    
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification
{
    //这里，你就可以通过notification的useinfo，干一些你想做的事情了
    
    if (application.applicationState != UIApplicationStateActive) {
        application.applicationIconBadgeNumber = application.applicationIconBadgeNumber-1;
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *currentDeviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSCharacterSet * str = [NSCharacterSet characterSetWithCharactersInString:@" "];
    currentDeviceToken = [[currentDeviceToken componentsSeparatedByCharactersInSet:str] componentsJoinedByString:@""];
    NSLog(@"currentDeviceToken:%@",currentDeviceToken);
    
    if (![currentDeviceToken isEqualToString:[[WPGlobalConfig shared] deviceToken]]) {
        // deviceToken发生改变了
        [[WPGlobalConfig shared] setDeviceToken:currentDeviceToken];
        
        [[WPGlobalConfig shared] setDeviceTokenNeedRegister:@"Y"];
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
//    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
//    NSLog(@"register for remote notification err:%@",str);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"notification:%@", userInfo);
    
    if (application.applicationState != UIApplicationStateActive) {
        application.applicationIconBadgeNumber = application.applicationIconBadgeNumber-1;
    }
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif

#pragma mark - extern Methods

- (void)showAlertViewWithString:(NSString *)aString
{
    UIAlertView *tempAlert = [[UIAlertView alloc]initWithTitle:aString
                                                       message:nil
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
    [tempAlert show];
}

- (void)showInfoPanelInView:(UIView *)aParentView
                      title:(NSString *)title
                  hideAfter:(NSInteger)interval
{
    [MKInfoPanel showPanelInView:aParentView
                            type:MKInfoPanelTypeInfo
                           title: title
                        subtitle:nil
                       hideAfter:interval];
}

@end
