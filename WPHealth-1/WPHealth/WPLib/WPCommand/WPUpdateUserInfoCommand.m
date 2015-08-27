//
//  WPUpdateUserInfoCommand.m
//  WPHealth
//
//  Created by justone on 14/11/28.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPUpdateUserInfoCommand.h"

@implementation WPUpdateUserInfoCommand

- (void)postCommandWithSuccess:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure
{
    [super postCommandWithRequestPath:@"/users/update"
                              success:aSuccess
                              failure:aFailure];
}

@end
