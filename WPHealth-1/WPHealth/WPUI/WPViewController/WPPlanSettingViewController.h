//
//  WPPlanSettingViewController.h
//  WPHealth
//
//  Created by justone on 15/5/28.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPPlanSettingViewController : WPBaseViewController

@property (nonatomic, strong) WPContentPlan* contentPlan;

@property (nonatomic, strong) void (^lastBtnBlock)(void);
@property (nonatomic, strong) void (^finishBtnBlock)(WPContentPlan* aContentPlan);

@end
