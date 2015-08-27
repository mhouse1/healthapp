//
//  WPNotificationRegisterCommand.m
//  WPHealth
//
//  Created by justone on 15/1/13.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPNotificationRegisterCommand.h"

@implementation WPNotificationRegisterCommand

- (void)postCommandWithSuccess:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure
{
    [super postCommandWithRequestPath:@"/notification/register"
                              success:aSuccess
                              failure:aFailure];
}

@end
