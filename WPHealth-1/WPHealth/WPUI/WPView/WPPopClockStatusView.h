//
//  WPPopClockStatusView.h
//  WPHealth
//
//  Created by justone on 15/6/2.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPPopClockStatusView : UIView

- (id)initWithPlanName:(NSString *)aPlanName status:(BOOL)aStatus;

- (void)show;

- (void)dismiss;

@end
