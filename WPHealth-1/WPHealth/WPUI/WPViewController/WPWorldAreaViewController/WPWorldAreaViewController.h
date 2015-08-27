//
//  WPWorldAreaViewController.h
//  CYTest
//
//  Created by justone on 14/10/31.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPBaseViewController.h"
#import "WPWorldAreaTree.h"

@interface WPWorldAreaViewController : WPBaseViewController

@property (nonatomic, strong) IBOutlet UITableView *worldTableView;

@property (nonatomic, strong) ZRPTreeNode *rootTreeNode;

@end
