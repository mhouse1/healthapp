//
//  WPContentModel.m
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPContentModel.h"

@implementation WPContentPlanModel
{
    NSMutableArray *_planInfoArray;
    NSMutableArray *_selectedPlanInfoArray;
}

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        _planInfoArray = [NSMutableArray arrayWithCapacity:0];
        _selectedPlanInfoArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    [self clear];
    [self clearSelectedArray];
}

#pragma mark - extern Methods

- (void)clear
{
    [_planInfoArray removeAllObjects];
}

- (void)addContentPlan:(WPContentPlan *)aContentPlan
{
    [_planInfoArray addObject:aContentPlan];
}

- (WPContentPlan *)contentPlanAtIndex:(NSInteger)aIndex
{
    if (aIndex >= [_planInfoArray count]) {
        return nil;
    }
    return [_planInfoArray objectAtIndex:aIndex];
}

- (NSArray *)planList
{
    return _planInfoArray;
}

- (NSInteger)count
{
    return [_planInfoArray count];
}

- (void)clearSelectedArray
{
    [_selectedPlanInfoArray removeAllObjects];
}

- (void)addSelectedContentPlan:(WPContentPlan *)aContentPlan
{
    [_selectedPlanInfoArray addObject:aContentPlan];
}

- (WPContentPlan *)selectedContentPlanAtIndex:(NSInteger)aIndex
{
    if (aIndex >= [_selectedPlanInfoArray count]) {
        return nil;
    }
    return [_selectedPlanInfoArray objectAtIndex:aIndex];
}

- (NSArray *)selectedPlanList
{
    return _selectedPlanInfoArray;
}

- (NSInteger)selectedCount
{
    return [_selectedPlanInfoArray count];
}

@end


