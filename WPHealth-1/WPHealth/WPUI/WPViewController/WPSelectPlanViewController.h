//
//  WPSelectPlanViewController.h
//  WPHealth
//
//  Created by justone on 15/5/28.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPSelectPlanViewController : WPBaseViewController

@property (nonatomic, strong) void (^finishedBlock)(WPContentPlan* aContentPlan);

@end
