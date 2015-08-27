//
//  ZRPTreeNode.h
//  ZRP
//
//  Created by QQ on 12-3-28.
//  Copyright 2012 中瑞普. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZRPTreeNode : NSObject 
{
	NSMutableArray	*children;		//子节点
	NSString		*title;			//节点要显示的文字
	NSString		*key;			//主键，在树中唯一
	id				data;			//节点可以包含任意数据
	BOOL			expanded;		//标志：节点是否已展开，保留给ZRPTreeViewCell使用的
	BOOL			hidden;			//标志，节点是否隐藏
	int				deep;			//节点位于树的第几层,ZRPTreeViewCell使用
}

@property (nonatomic, assign) ZRPTreeNode *p_node;
@property (nonatomic, retain) id data;
@property (nonatomic, retain) NSString *title, *key;
@property (nonatomic, assign) BOOL expanded, hidden;
@property (nonatomic, assign) BOOL editEnable;  //扩展字段
@property (nonatomic, retain) NSMutableArray *children;
@property (nonatomic, assign) BOOL isNullNode;

@property (nonatomic, strong) NSNumber *projectType;
@property (nonatomic, strong) NSString *timeCount;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, assign) NSInteger heat;
@property (nonatomic, assign) BOOL isSelected;

- (int)deep;
- (void)setDeep:(int)aValue;			//设置节点位于树的第几层

- (BOOL)hasChildren;
- (int)childrenCount;
- (void)addChild:(ZRPTreeNode*)aChild;	//添加子节点
- (void)removeChild:(ZRPTreeNode*)aChild;	//移除子节点

// 通过Key值获得节点
+ (ZRPTreeNode*)findNodeByKey:(NSString*)aKey andNode:(ZRPTreeNode*)aNode;

// 通过节点获得子节点列表
+ (void)getNodes:(ZRPTreeNode*)aRoot andReturnedArray:(NSMutableArray*)aArray;

// 通过节点获得所有子节点列表
+ (void)getNodes:(ZRPTreeNode*)aRoot andReturnedAllArray:(NSMutableArray*)aArray;

@end
