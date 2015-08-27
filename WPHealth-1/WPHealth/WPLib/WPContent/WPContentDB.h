//
//  WPContentDB.h
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPContentModel.h"
#import "WPContentConvert.h"

@interface WPContentDB : NSObject

+ (WPContentDB *)shared;

#pragma mark - exit

- (void)clearContentCurrentUserInfo;

#pragma mark - current plan

// 插入计划
- (void)insertContentPlan:(WPContentPlan *)aContentPlan;

// 更新计划
- (void)updateContentPlan:(WPContentPlan *)aContentPlan;

// 获取指定用户的计划列表
- (NSArray *)getContentPlanList:(NSString *)aUserId;

#pragma mark - current user

// 插入当前用户
- (void)insertContentCurrentUser:(WPContentCurrentUser *)aContentCurrentUser;

// 更新当前用户
- (void)updateContentCurrentUser:(WPContentCurrentUser *)aContentCurrentUser;

// 获取当前用户
- (WPContentCurrentUser *)getContentCurrentUser;

@end
