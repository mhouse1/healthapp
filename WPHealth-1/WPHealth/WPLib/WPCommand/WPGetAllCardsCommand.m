//
//  WPGetAllCardsCommand.m
//  WPHealth
//
//  Created by justone on 15/6/15.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPGetAllCardsCommand.h"

@implementation WPGetAllCardsCommand

- (void)postCommandWithSuccess:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure
{
    [super postCommandWithRequestPath:@"/cards/"
                              success:aSuccess
                              failure:aFailure];
}

@end
