//
//  WPContentConvert.m
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPContentConvert.h"

WPContentPlan *convertLocalPlanToContentPlan(NSDictionary *aPlanDict)
{
    WPContentPlan *contentPlan = [[WPContentPlan alloc] init];
    
    contentPlan.plan_id = [aPlanDict objectForKey:@"planId"];
    contentPlan.iconNameColor = [aPlanDict objectForKey:@"iconNameColor"];
    contentPlan.iconNameWhite = [aPlanDict objectForKey:@"iconNameWhite"];
    contentPlan.planName = [aPlanDict objectForKey:@"planName"];
    contentPlan.selectedTime = [aPlanDict objectForKey:@"selectedTime"];
    
    NSString *canSelectedTimeList = [aPlanDict objectForKey:@"canSelectedTimeList"];
    contentPlan.canSelectedTimeArray = [canSelectedTimeList componentsSeparatedByString:@"&"];
    
    contentPlan.isPlanFinished = [NSString stringWithFormat:@"%@", [aPlanDict objectForKey:@"isPlanFinished"]];
    
    contentPlan.summary = [aPlanDict objectForKey:@"summary"];
    
    contentPlan.sportTime = @"30分钟";
    contentPlan.dayOfWeek = @"1天";
    contentPlan.notifyStatus = @"1";
    
    return contentPlan;
}

WPContentPlan *convertToContentPlan(NSDictionary *aPlanDict)
{
    WPContentPlan *contentPlan = [[WPContentPlan alloc] init];
    
    contentPlan.plan_id = [NSString stringWithFormat:@"%@", [aPlanDict objectForKey:@"planId"]];
    contentPlan.iconNameColor = [NSString stringWithFormat:@"%@", [aPlanDict objectForKey:@"blueIcon"]];
    contentPlan.iconNameWhite = [NSString stringWithFormat:@"%@", [aPlanDict objectForKey:@"whiteIcon"]];
    contentPlan.planName = [NSString stringWithFormat:@"%@", [aPlanDict objectForKey:@"name"]];
    contentPlan.selectedTime = [NSString stringWithFormat:@"%@", [aPlanDict objectForKey:@"targetValue"]];
    
    NSArray *planNameArray = [contentPlan.planName componentsSeparatedByString:@"@"];
    if ([planNameArray count] > 1) {
        contentPlan.planName = [planNameArray firstObject];
    }
    
    NSArray *canSelectedTimeList = [aPlanDict objectForKey:@"valueArray"];
    contentPlan.canSelectedTimeArray = canSelectedTimeList;
    
    contentPlan.isPlanFinished = @"NO";
    
    contentPlan.summary = [aPlanDict objectForKey:@"summary"];
    
    contentPlan.sportTime = @"30分钟";
    contentPlan.dayOfWeek = @"1天";
    contentPlan.notifyStatus = @"1";
    
    return contentPlan;
}

