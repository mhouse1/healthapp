//
//  WPContentService.m
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPContentService.h"
#import "WPUtil.h"

@implementation WPContentService
{
    NSTimer *_serviceTimer;
    
    WPContentCurrentUser *_contentCurrentUser;
    WPContentPlanModel *_contentPlanModel;
}

#pragma mark - Timer

- (void)handleServiceTimer:(NSTimer *)aTimer
{
    if ([[self contentCurrentUser].user_id length] > 0 || [[self contentCurrentUser].user_nick length] > 0) {
        for (NSInteger index = 0; index < [[self contentPlanModel] count]; index++) {
            WPContentPlan *contentPlan = [[self contentPlanModel] contentPlanAtIndex:index];
            
            NSString *date = [NSString stringWithFormat:@"%@ %@:00", WPCurrentDateString(), contentPlan.selectedTime];
            NSInteger numberOfMinutes = numberOfSecondsFromTodayByTime(date, @"yyyy-MM-dd HH:mm:ss");
            if (numberOfMinutes >= 0 && numberOfMinutes <= 60) {
                NSLog(@"handleServiceTimer date %@, numberOfMinutes %@", date, @(numberOfMinutes));
                return;
            }
        }
    }
}

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    
}

+ (WPContentService *)shared
{
    static WPContentService *contentService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contentService = [[WPContentService alloc] init];
    });
    return contentService;
}


#pragma mark - extern Methods

- (void)startTimer
{
    _serviceTimer = [NSTimer scheduledTimerWithTimeInterval:60
                                                     target:self
                                                   selector:@selector(handleServiceTimer:)
                                                   userInfo:nil
                                                    repeats:YES];
    [_serviceTimer fire];
}

- (void)stopTimer
{
    [_serviceTimer invalidate];
    _serviceTimer = nil;
}

- (void)clearContentService
{
    _contentCurrentUser = nil;
    _contentPlanModel = nil;
}

- (WPContentCurrentUser *)contentCurrentUser
{
    if (!_contentCurrentUser) {
        _contentCurrentUser = [[WPContentDB shared] getContentCurrentUser];
    }
    return _contentCurrentUser;
}

- (void)insertContentCurrentUser
{
    [[WPContentDB shared] insertContentCurrentUser:_contentCurrentUser];
}

- (void)updateContentCurrentUser
{
    [[WPContentDB shared] updateContentCurrentUser:_contentCurrentUser];
}

- (void)updateContentCurrentUserCoinCount:(WPContentPlan *)aContentPlan
{
    // 处理不同计划、不同金币数
    if ([aContentPlan.planName isEqualToString:@"起床"]) {
        NSInteger wakeUpCoinCount = [[self contentCurrentUser].wakeUpCoinCount integerValue];
        [self contentCurrentUser].wakeUpCoinCount = [NSString stringWithFormat:@"%d", wakeUpCoinCount+WPCoinCountOfEveryPlan];
    } else if ([aContentPlan.planName isEqualToString:@"早餐"]) {
        NSInteger breakfastCoinCount = [[self contentCurrentUser].breakfastCoinCount integerValue];
        [self contentCurrentUser].breakfastCoinCount = [NSString stringWithFormat:@"%d", breakfastCoinCount+WPCoinCountOfEveryPlan];
    } else if ([aContentPlan.planName isEqualToString:@"喝水"]) {
        NSInteger waterCoinCount = [[self contentCurrentUser].waterCoinCount integerValue];
        [self contentCurrentUser].waterCoinCount = [NSString stringWithFormat:@"%d", waterCoinCount+WPCoinCountOfEveryPlan];
    } else if ([aContentPlan.planName isEqualToString:@"午餐"]) {
        NSInteger lunchCoinCount = [[self contentCurrentUser].lunchCoinCount integerValue];
        [self contentCurrentUser].lunchCoinCount = [NSString stringWithFormat:@"%d", lunchCoinCount+WPCoinCountOfEveryPlan];
    } else if ([aContentPlan.planName isEqualToString:@"晚餐"]) {
        NSInteger dinnerCoinCount = [[self contentCurrentUser].dinnerCoinCount integerValue];
        [self contentCurrentUser].dinnerCoinCount = [NSString stringWithFormat:@"%d", dinnerCoinCount+WPCoinCountOfEveryPlan];
    } else if ([aContentPlan.planName isEqualToString:@"便便"]) {
        NSInteger bianbianCoinCount = [[self contentCurrentUser].bianbianCoinCount integerValue];
        [self contentCurrentUser].bianbianCoinCount = [NSString stringWithFormat:@"%d", bianbianCoinCount+WPCoinCountOfEveryPlan];
    } else if ([aContentPlan.planName isEqualToString:@"睡觉"]) {
        NSInteger sleepCoinCount = [[self contentCurrentUser].sleepCoinCount integerValue];
        [self contentCurrentUser].sleepCoinCount = [NSString stringWithFormat:@"%d", sleepCoinCount+WPCoinCountOfEveryPlan];
    } else if ([aContentPlan.planName isEqualToString:@"有氧运动"]) {
        NSInteger youyangSportCoinCount = [[self contentCurrentUser].youyangSportCoinCount integerValue];
        [self contentCurrentUser].youyangSportCoinCount = [NSString stringWithFormat:@"%d", youyangSportCoinCount+WPCoinCountOfEveryPlan];
    } else if ([aContentPlan.planName isEqualToString:@"无氧运动"]) {
        NSInteger wuyangSportCoinCount = [[self contentCurrentUser].wuyangSportCoinCount integerValue];
        [self contentCurrentUser].wuyangSportCoinCount = [NSString stringWithFormat:@"%d", wuyangSportCoinCount+WPCoinCountOfEveryPlan];
    }
    
    NSInteger coinCountOfEveryDay = [[self contentCurrentUser].coinCountOfEveryDay integerValue];
    [self contentCurrentUser].coinCountOfEveryDay = [NSString stringWithFormat:@"%d", coinCountOfEveryDay+WPCoinCountOfEveryPlan];
    
    NSInteger totalCoinCount = [[self contentCurrentUser].totalCoinCount integerValue];
    [self contentCurrentUser].totalCoinCount = [NSString stringWithFormat:@"%d", totalCoinCount+WPCoinCountOfEveryPlan];
    
    [self updateContentCurrentUser];
}

- (void)updateContentCurrentUserBonusCoinCount:(NSInteger)aCount
{
    NSInteger coinCountOfEveryDay = [[self contentCurrentUser].coinCountOfEveryDay integerValue];
    [self contentCurrentUser].coinCountOfEveryDay = [NSString stringWithFormat:@"%d", coinCountOfEveryDay+aCount];
    
    NSInteger totalCoinCount = [[self contentCurrentUser].totalCoinCount integerValue];
    [self contentCurrentUser].totalCoinCount = [NSString stringWithFormat:@"%d", totalCoinCount+aCount];
    
    [self updateContentCurrentUser];
}

- (WPContentPlanModel *)contentPlanModel
{
    if (!_contentPlanModel) {
        _contentPlanModel = [[WPContentPlanModel alloc] init];
        
        NSArray *planList = [[WPContentDB shared] getContentPlanList:[self contentCurrentUser].user_id];
        if (planList == nil || [planList count] <= 0) {
            planList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"planInfo" ofType:@"plist"]];
            // 首次安装，并且未获取到计划列表，需插入本地数据库表
            for (NSInteger index = 0; index < [planList count]; index++) {
                NSDictionary *planDict = [planList objectAtIndex:index];
                NSMutableDictionary *planAddedIdDict = [NSMutableDictionary dictionaryWithDictionary:planDict];
                [planAddedIdDict setObject:[NSString stringWithFormat:@"%@", @(index)] forKey:@"planId"];
                WPContentPlan *contentPlan = convertLocalPlanToContentPlan(planAddedIdDict);
                contentPlan.user_id = [self contentCurrentUser].user_id;
                [[WPContentDB shared] insertContentPlan:contentPlan];
                
                [_contentPlanModel addContentPlan:contentPlan];
                
                if (index < 3) {
                    [_contentPlanModel addSelectedContentPlan:contentPlan];
                }
            }
        } else {
            for (NSInteger index = 0; index < [planList count]; index++) {
                WPContentPlan *contentPlan = [planList objectAtIndex:index];
                [_contentPlanModel addContentPlan:contentPlan];
                
                if (index < 3) {
                    [_contentPlanModel addSelectedContentPlan:contentPlan];
                }
            }
        }
    }
    return _contentPlanModel;
}

@end
