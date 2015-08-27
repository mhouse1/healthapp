//
//  WPLoginOutCommand.m
//  WPHealth
//
//  Created by justone on 14/12/4.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPLoginOutCommand.h"

@implementation WPLoginOutCommand

- (void)postCommandWithSuccess:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure
{
    [super postCommandWithRequestPath:@"/login/signout"
                              success:aSuccess
                              failure:aFailure];
}

@end
