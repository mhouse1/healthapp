//
//  WPLoginCommand.h
//  WPHealth
//
//  Created by justone on 14-9-2.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPCommand.h"

// 登录
@interface WPLoginCommand : WPCommand

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

- (void)postCommandWithSuccess:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure;

@end
