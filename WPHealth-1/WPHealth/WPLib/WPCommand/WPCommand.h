//
//  WPCommand.h
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPGlobalConfig.h"
#import "GTMBase64.h"
#import "WPUtil.h"

@interface WPCommand : NSObject

- (void)getCommandWithRequestPath:(NSString *)aRequestPath
                          success:(void (^)(NSDictionary *aResponseDict))aSuccess
                          failure:(void (^)(NSError *aError))aFailure;

- (void)postCommandWithRequestPath:(NSString *)aRequestPath
                           success:(void (^)(NSDictionary *aResponseDict))aSuccess
                           failure:(void (^)(NSError *aError))aFailure;

@end
