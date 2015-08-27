//
//  WPLoginOutCommand.h
//  WPHealth
//
//  Created by justone on 14/12/4.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPCommand.h"

// 用户注销
@interface WPLoginOutCommand : WPCommand

- (void)postCommandWithSuccess:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure;

@end
