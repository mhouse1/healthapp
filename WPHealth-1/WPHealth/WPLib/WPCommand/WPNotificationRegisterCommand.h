//
//  WPNotificationRegisterCommand.h
//  WPHealth
//
//  Created by justone on 15/1/13.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPCommand.h"

// 注册推送通知
@interface WPNotificationRegisterCommand : WPCommand

@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *timeZoneString;

- (void)postCommandWithSuccess:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure;

@end
