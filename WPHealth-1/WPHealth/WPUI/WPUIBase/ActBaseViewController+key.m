//
//  ActBaseViewController+key.m
//  WPHealth
//
//  Created by justone on 15/5/26.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPBaseViewController.h"

@implementation WPBaseViewController (Key)

- (NSString *)wpViewControllerKey:(NSString *)aUserID
{
    return [NSString stringWithFormat:@"WPViewControllerKey%@", aUserID];
}

- (NSString *)wpViewControllerKey
{
    return @"WPViewControllerKey";
}

@end
