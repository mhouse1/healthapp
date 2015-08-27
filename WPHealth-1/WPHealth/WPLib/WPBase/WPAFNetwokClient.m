//
//  WPAFNetwokClient.m
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPAFNetwokClient.h"
#import "WPGlobalConfig.h"

@implementation WPAFNetwokClient

+ (WPAFNetwokClient *)shared
{
    static WPAFNetwokClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",WPBASEURL]];
        client = [[WPAFNetwokClient alloc] initWithBaseURL:baseUrl];
        [client setParameterEncoding:AFJSONParameterEncoding];
    });
    return client;
}

@end
