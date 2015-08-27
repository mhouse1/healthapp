//
//  WPAFNetwokClient.h
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface WPAFNetwokClient : AFHTTPClient

+ (WPAFNetwokClient *)shared;

@end
