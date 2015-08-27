//
//  WPContentModel.h
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPContent.h"

// 计划Model
@interface WPContentPlanModel : NSObject

- (void)clear;

- (void)addContentPlan:(WPContentPlan *)aContentPlan;

- (WPContentPlan *)contentPlanAtIndex:(NSInteger)aIndex;

- (NSArray *)planList;

- (NSInteger)count;


- (void)clearSelectedArray;

- (void)addSelectedContentPlan:(WPContentPlan *)aContentPlan;

- (WPContentPlan *)selectedContentPlanAtIndex:(NSInteger)aIndex;

- (NSArray *)selectedPlanList;

- (NSInteger)selectedCount;

@end
