//
//  WPSelectPlanViewController.m
//  WPHealth
//
//  Created by justone on 15/5/28.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPSelectPlanViewController.h"
#import "WPSelectPlanGridCell.h"
#import "GMGridView.h"

#define GRID_CELL_WIDTH     90.
#define GRID_CELL_HEIGHT    90.

#define ITEM_SPACING        5.

@interface WPSelectPlanViewController ()<GMGridViewDataSource,
GMGridViewActionDelegate>

@property (nonatomic, strong) GMGridView* gridView;

@property (nonatomic, strong) WPContentPlanModel *contentPlanModel;

@property (nonatomic, strong) NSMutableArray *selectedPlanArray;

@end

@implementation WPSelectPlanViewController

#pragma mark - custom Methods

- (BOOL)isExistedPlan:(WPContentPlan *)aPlan
{
    __block BOOL isExisted = NO;
    [self.selectedPlanArray enumerateObjectsUsingBlock:^(WPContentPlan *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.plan_id isEqualToString:aPlan.plan_id]) {
            isExisted = YES;
            *stop = YES;
        }
    }];
    return isExisted;
}

- (CGFloat)scrollViewHeight
{
    CGFloat height = 106.;
    if (WPMAINSCREEN_SIZE.width > 320.) {
        height = WPMAINSCREEN_SIZE.width*(106./320.);
    }
    return height;
}

#pragma mark - loaView

- (void)createGridView
{
    CGFloat left_space = (WPMAINSCREEN_SIZE.width-GRID_CELL_WIDTH*3-ITEM_SPACING*3)/2;
    
    self.gridView = [[GMGridView alloc] initWithFrame:CGRectMake(left_space, ITEM_SPACING, WPMAINSCREEN_SIZE.width-left_space*2, self.view.frame.size.height-ITEM_SPACING*2-64.-[self scrollViewHeight])];
    self.gridView.showsVerticalScrollIndicator = NO;
    self.gridView.backgroundColor = [UIColor clearColor];
    self.gridView.opaque = NO;
    self.gridView.clipsToBounds = NO;
    self.gridView.dataSource = self;
    self.gridView.actionDelegate = self;
    self.gridView.itemSpacing = 0.0;
    self.gridView.minEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    
    [self.view addSubview:self.gridView];

    [self.gridView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentPlanModel = [[WPContentService shared] contentPlanModel];
    
    [self createGridView];
}

- (void)reloadData
{
    NSMutableArray *selectedPlanArray = [NSMutableArray arrayWithArray:[[[WPContentService shared] contentPlanModel] selectedPlanList]];
    self.selectedPlanArray = selectedPlanArray;
    
    [self.gridView reloadData];
}

#pragma mark -  GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    if (position < [self.contentPlanModel count]) {
        GMGridViewCell *cell = [gridView cellForItemAtIndex:position];
        WPSelectPlanGridCell *selectPlanGridCell = (WPSelectPlanGridCell *)[cell.contentView viewWithTag:10000];
        WPContentPlan* contentPlan = [self.contentPlanModel contentPlanAtIndex:position];
        
        NSLog(@"selected planName: %@", contentPlan.planName);
        if ([self isExistedPlan:contentPlan]) {
            
        } else {
            [self.selectedPlanArray addObject:contentPlan];
            [selectPlanGridCell setSelected:YES];
            
            if (self.finishedBlock) {
                self.finishedBlock(contentPlan);
            }
        }
    }
}

#pragma mark - GMGridViewDataSource

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [self.contentPlanModel count];
}

- (CGSize)sizeForItemsInGMGridView:(GMGridView *)gridView
{
    return CGSizeMake(GRID_CELL_WIDTH, GRID_CELL_HEIGHT);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)aGridView cellForItemAtIndex:(NSInteger)aIndex
{
    CGRect itemRect = CGRectMake(0, 0,GRID_CELL_WIDTH, GRID_CELL_HEIGHT);
    
    GMGridViewCell *cell = [aGridView dequeueReusableCell];
    if (!cell) {
        cell = [[GMGridViewCell alloc] init];
        
        UIView *tempContentView = [[UIView alloc] initWithFrame:itemRect];
        cell.contentView = tempContentView;
    }
    if (cell.contentView) {
        [cell.contentView removeFromSuperview];
        cell.contentView = nil;
        
        UIView *tempContentView = [[UIView alloc] initWithFrame:itemRect];
        cell.contentView = tempContentView;
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    WPSelectPlanGridCell *selectPlanGridCell = [[WPSelectPlanGridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, GRID_CELL_WIDTH, GRID_CELL_HEIGHT-ITEM_SPACING)];
    selectPlanGridCell.tag = 10000;
    [cell.contentView addSubview:selectPlanGridCell];
    
    if (aIndex < [self.contentPlanModel count]) {
        WPContentPlan* contentPlan = [self.contentPlanModel contentPlanAtIndex:aIndex];
        
        [selectPlanGridCell.contentBtn setTitle:contentPlan.planName forState:UIControlStateNormal];
        [selectPlanGridCell.contentBtn setImage:[UIImage imageNamed:contentPlan.iconNameColor] forState:UIControlStateNormal];
        
        if ([self isExistedPlan:contentPlan]) {
            [selectPlanGridCell setSelected:YES];
            NSLog(@"isExistedPlan %@", contentPlan.planName);
        }
    }
    
    return cell;
}

@end
