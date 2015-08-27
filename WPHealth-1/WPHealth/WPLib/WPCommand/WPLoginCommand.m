//
//  WPLoginCommand.m
//  WPHealth
//
//  Created by justone on 14-9-2.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPLoginCommand.h"

@implementation WPLoginCommand

- (void)postCommandWithSuccess:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure
{
    [super postCommandWithRequestPath:@"/help/Api/GET-tables-UserProfile"//"/login/signin"
                              success:aSuccess
                              failure:aFailure];
}

@end
