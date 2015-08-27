//
//  WPWorldAreaTree.m
//  CYTest
//
//  Created by justone on 14/10/31.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPWorldAreaTree.h"

@implementation WPWorldAreaTree
{
    ZRPTreeNode *_rootTreeNode;
}

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        _rootTreeNode = [self loadRootTreeNode];
    }
    return self;
}

- (void)dealloc
{
    
}

+ (WPWorldAreaTree *)shared
{
    static WPWorldAreaTree *worldAreaTree = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        worldAreaTree = [[WPWorldAreaTree alloc] init];
    });
    return worldAreaTree;
}

#pragma mark - custom Methods

- (ZRPTreeNode *)loadRootTreeNode
{
    NSError *error = nil;
    NSString *path = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath],@"/worldArea.txt"];
    if (path == nil || [path length] <= 0) {
        return nil;
    }
    NSString *contentStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!contentStr || [contentStr length] <= 1) {
        return nil;
    }
    NSArray *array = [contentStr componentsSeparatedByString:@"\n"];
    if ([array count] <= 0) {
        return nil;
    }
    
    ZRPTreeNode *rootTree = [[ZRPTreeNode alloc]init];
    rootTree.deep = 0;
    rootTree.title = @"根节点";
    rootTree.hidden = YES;
    rootTree.expanded = YES;
    
    for (int index = 0; index < [array count]; ++index) {
        if (index == 2594) {
            //2594 后面的为繁体名字
            //5188 后面的为英文名字
            break;
        }
        
        NSString *tmpArea = [array objectAtIndex:index];
        NSArray *tmpArray = [tmpArea componentsSeparatedByString:@"|"];
        if ([tmpArray count] == 3) {
            NSString *tmpName = [tmpArray objectAtIndex:1];
            NSArray *tmpNameArray = [tmpName componentsSeparatedByString:@"_"];
            if ([tmpNameArray count] == 1) {
                NSString *country = [tmpArray objectAtIndex:2];
                //NSLog(@"%d【%@】", index, country);
                
                ZRPTreeNode *newNode = [[ZRPTreeNode alloc] init];
                newNode.title = country;
                newNode.expanded = NO;
                newNode.key = [tmpNameArray objectAtIndex:0];
                
                [newNode setDeep:rootTree.deep+1];
                [rootTree addChild:newNode];
                
            } else if ([tmpNameArray count] == 2) {
                NSString *key = [tmpNameArray objectAtIndex:0];
                ZRPTreeNode *currentNode = [ZRPTreeNode findNodeByKey:key andNode:rootTree];
                
                NSString *province = [tmpArray objectAtIndex:2];
                //NSLog(@"        %@", province);
                ZRPTreeNode *newNode = [[ZRPTreeNode alloc] init];
                newNode.title = province;
                newNode.expanded = NO;
                newNode.key = [tmpNameArray objectAtIndex:1];
                
                [newNode setDeep:currentNode.deep+1];
                [currentNode addChild:newNode];
            } else if ([tmpNameArray count] == 3) {
                NSString *key = [tmpNameArray objectAtIndex:1];
                ZRPTreeNode *currentNode = [ZRPTreeNode findNodeByKey:key andNode:rootTree];
                
                NSString *city = [tmpArray objectAtIndex:2];
                //NSLog(@"                %@", city);
                ZRPTreeNode *newNode = [[ZRPTreeNode alloc] init];
                newNode.title = city;
                newNode.expanded = NO;
                newNode.key = [tmpNameArray objectAtIndex:2];
                
                [newNode setDeep:currentNode.deep+1];
                [currentNode addChild:newNode];
            }
        }
    }
    NSLog(@"WPWorldAreaTree loadFinish");
    return rootTree;
}

#pragma mark - extern Methods

- (ZRPTreeNode *)rootTreeNode
{
    return _rootTreeNode;
}

@end
