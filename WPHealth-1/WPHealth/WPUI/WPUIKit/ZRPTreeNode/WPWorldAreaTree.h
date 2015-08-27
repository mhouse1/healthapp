//
//  WPWorldAreaTree.h
//  CYTest
//
//  Created by justone on 14/10/31.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZRPTreeNode.h"

@interface WPWorldAreaTree : NSObject

+ (WPWorldAreaTree *)shared;

// 国家－》省－》城市
- (ZRPTreeNode *)rootTreeNode;

@end
