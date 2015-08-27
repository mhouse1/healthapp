//
//  WPContentConvert.h
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPContentModel.h"

// 本地计划结构转换
WPContentPlan *convertLocalPlanToContentPlan(NSDictionary *aPlanDict);

// 计划结构转换
WPContentPlan *convertToContentPlan(NSDictionary *aPlanDict);
