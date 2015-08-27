//
//  WPRegisterCommand.m
//  WPHealth
//
//  Created by justone on 14-9-2.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPRegisterCommand.h"

@implementation WPRegisterCommand

- (void)postCommandWithSuccess:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure
{
    [super postCommandWithRequestPath:@"/users/add"
                              success:aSuccess
                              failure:aFailure];
}

@end
