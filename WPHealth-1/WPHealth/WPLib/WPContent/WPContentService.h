//
//  WPContentService.h
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPContentDB.h"
#import "WPGlobalConfig.h"

@interface WPContentService : NSObject

+ (WPContentService *)shared;

// 后台定时服务启动/关闭
- (void)startTimer;
- (void)stopTimer;

// 清空缓存
- (void)clearContentService;

// 当前用户
- (WPContentCurrentUser *)contentCurrentUser;

// 插入当前用户
- (void)insertContentCurrentUser;

// 更新当前用户
- (void)updateContentCurrentUser;

// 更新当前用户金币个数
- (void)updateContentCurrentUserCoinCount:(WPContentPlan *)aContentPlan;

// 更新当前用户 通过额外奖励的金币个数
- (void)updateContentCurrentUserBonusCoinCount:(NSInteger)aCount;

// 当前用户或关心的人的计划Model
- (WPContentPlanModel *)contentPlanModel;

@end
