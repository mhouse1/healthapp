//
//  WPGetAllCardsCommand.h
//  WPHealth
//
//  Created by justone on 15/6/15.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPCommand.h"

@interface WPGetAllCardsCommand : WPCommand

- (void)postCommandWithSuccess:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure;

@end
