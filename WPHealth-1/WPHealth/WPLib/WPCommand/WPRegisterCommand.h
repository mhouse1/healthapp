//
//  WPRegisterCommand.h
//  WPHealth
//
//  Created by justone on 14-9-2.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPCommand.h"

// 注册
@interface WPRegisterCommand : WPCommand

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *scope;

- (void)postCommandWithSuccess:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure;

@end
