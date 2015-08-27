//
//  WPCheckUserNameCommand.h
//  WPHealth
//
//  Created by justone on 14/12/4.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPCommand.h"

// 测试用户名是否存在
@interface WPCheckUserNameCommand : WPCommand

- (void)postCommandWithUserName:(NSString *)aUserName
                        success:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure;

@end
