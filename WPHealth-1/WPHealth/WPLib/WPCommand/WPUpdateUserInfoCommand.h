//
//  WPUpdateUserInfoCommand.h
//  WPHealth
//
//  Created by justone on 14/11/28.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPCommand.h"

// 更新用户信息
@interface WPUpdateUserInfoCommand : WPCommand

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *address;

- (void)postCommandWithSuccess:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure;

@end
