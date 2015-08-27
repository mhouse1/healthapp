//
//  WPPlanSummaryViewController.h
//  WPHealth
//
//  Created by justone on 15/5/28.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPPlanSummaryViewController : WPBaseViewController

@property (nonatomic, strong) WPContentPlan* contentPlan;

@property (nonatomic, strong) void (^lastBtnBlock)(void);
@property (nonatomic, strong) void (^nextBtnBlock)(void);

- (void)reloadData;

@end
