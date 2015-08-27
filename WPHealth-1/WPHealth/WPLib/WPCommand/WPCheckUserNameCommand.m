//
//  WPCheckUserNameCommand.m
//  WPHealth
//
//  Created by justone on 14/12/4.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPCheckUserNameCommand.h"

@implementation WPCheckUserNameCommand

- (void)postCommandWithUserName:(NSString *)aUserName
                        success:(void (^)(NSDictionary *aResponseDict))aSuccess
                        failure:(void (^)(NSError *aError))aFailure
{
    [super getCommandWithRequestPath:[NSString stringWithFormat:@"/users/:username/%@", aUserName]
                             success:aSuccess
                             failure:aFailure];
}

@end
