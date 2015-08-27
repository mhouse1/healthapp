//
//  ZRPTreeNode.m
//  ZRP
//
//  Created by QQ on 12-3-28.
//  Copyright 2012 中瑞普. All rights reserved.
//

#import "ZRPTreeNode.h"


@implementation ZRPTreeNode

@synthesize p_node, children, data, title, key, expanded, hidden;
@synthesize editEnable;

#pragma mark -
#pragma mark init

- (id)init
{
	if (self = [super init])
	{
		//p_node = nil;
		children = nil;
		key = nil;
        self.editEnable = YES;
        self.isNullNode = NO;
	}
	return self;
}

- (void)dealloc
{
	//self.p_node = nil;
	self.data = nil;
	self.title = nil;
	self.key = nil;
	self.children = nil;
    self.isNullNode = NO;
}

#pragma mark -
#pragma mark Outside Methods

- (int)deep
{
	return p_node == nil ? 0 : p_node.deep+1;
}

- (void)setDeep:(int)aValue
{
	deep = aValue;
}

- (BOOL)hasChildren
{
	if(children == nil || children.count == 0)
		return NO;
	else 
		return YES;
}

- (int)childrenCount
{
	return children == nil ? 0 : children.count;
}

- (void)addChild:(ZRPTreeNode *)aChild
{
	if (children == nil)
	{
		children = [[NSMutableArray alloc] init];
	}
	aChild.p_node = self;	
	[children addObject:aChild];
}

- (void)removeChild:(ZRPTreeNode*)aChild
{
    if (children)
    {
        [children removeObject:aChild];
    }
}

+ (ZRPTreeNode*)findNodeByKey:(NSString*)aKey andNode:(ZRPTreeNode*)aNode
{
	if ([aKey isEqualToString:[aNode key]])
	{
		//如果node就匹配，返回node
		return aNode;
	}
	else if([aNode hasChildren])
	{
		//如果node有子节点，查找node 的子节点		
		for(ZRPTreeNode *each in [aNode children])
		{
			//NSLog(@"retrieve node:%@ %@",each.title,each.key);
			ZRPTreeNode *curNode = [ZRPTreeNode findNodeByKey:aKey andNode:each];
			if (curNode != nil) 
			{
				return curNode;
			}
		}
	}
	//如果node没有子节点,则查找终止,返回nil
	return nil;		
}

+ (void)getNodes:(ZRPTreeNode*)aRoot andReturnedArray:(NSMutableArray*)aArray
{
	if(![aRoot hidden])//只有节点被设置为“不隐藏”的时候才返回节点
		[aArray addObject:aRoot];
	if ([aRoot hasChildren] && [aRoot expanded])
	{
		for(ZRPTreeNode *each in [aRoot children])
		{
			[ZRPTreeNode getNodes:each andReturnedArray:aArray];
		}
	}
	return;
}

+ (void)getNodes:(ZRPTreeNode*)aRoot andReturnedAllArray:(NSMutableArray*)aArray
{
    if(![aRoot hidden])//只有节点被设置为“不隐藏”的时候才返回节点
		[aArray addObject:aRoot];
	if ([aRoot hasChildren])
	{
		for(ZRPTreeNode *each in [aRoot children])
		{
			[ZRPTreeNode getNodes:each andReturnedAllArray:aArray];
		}
	}
	return;
}

@end
