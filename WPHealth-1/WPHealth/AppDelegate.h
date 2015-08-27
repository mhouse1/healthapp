//
//  AppDelegate.h
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setRootTabBarController;

- (void)showAlertViewWithString:(NSString *)aString;

- (void)showInfoPanelInView:(UIView *)aParentView
                      title:(NSString *)title
                  hideAfter:(NSInteger)interval;

@end

#define APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)