//
//  WPModifyPasswordCommand.h
//  WPHealth
//
//  Created by justone on 14/12/4.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPCommand.h"

// 用户密码修改
@interface WPModifyPasswordCommand : WPCommand

@property (nonatomic, strong) NSString *currentPassword;
@property (nonatomic, strong) NSString *nowPassword;

- (void)postCommandWithSuccess:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure;

@end
