//
//  WPProvinceViewController.h
//  CYTest
//
//  Created by justone on 14/10/31.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPBaseViewController.h"
#import "WPWorldAreaTree.h"

@interface WPProvinceViewController : WPBaseViewController

@property (nonatomic, strong) IBOutlet UITableView *provinceTableView;

@property (nonatomic, strong) ZRPTreeNode *childrenTreeNode;

@end
