//
//  WPPlanViewController.m
//  WPHealth
//
//  Created by justone on 15-5-25.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPPlanViewController.h"
#import "WPAddPlanBoxViewController.h"
#import "WPGetAllCardsCommand.h"
#import "WPPlanTableCell.h"

@interface WPPlanViewController ()<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation WPPlanViewController

#pragma mark - loadData

- (void)loadData
{
    WPGetAllCardsCommand *getAllCardsCmd = [[WPGetAllCardsCommand alloc] init];
    
    [getAllCardsCmd postCommandWithSuccess:^(NSDictionary *aResponseDict) {
        NSLog(@"%@", aResponseDict);
    } failure:^(NSError *aError) {
        
    }];
}

#pragma mark - buttonAction

- (void)handleAddBtnEvent
{
    WPAddPlanBoxViewController *addPlanBoxVC = [[WPAddPlanBoxViewController alloc] init];
    //hides the tab selection controls if set to YES
    addPlanBoxVC.hidesBottomBarWhenPushed = NO;
    
    [self.navigationController pushViewController:addPlanBoxVC animated:YES];
}

#pragma mark - loadView

- (void)configNavigationView
{
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 24, 24.)];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add_btn.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(handleAddBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    
    [self.navigationItem setRightBarButtonItem:rightItem animated:NO];
}

- (void)configTableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 15.0)];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //hide separator line on cell
    //self.tableView.separatorColor = [UIColor clearColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    //(0., 0., self.tableView.frame.size.width, self.tableView.frame.size.height)];
    UIView* tableBgView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., 0., self.tableView.frame.size.height)];
    tableBgView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = tableBgView;
    tableBgView = nil;

    

    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad
{
    //edit the fourth paramter in CGRectMake(0,0,320,580);
    //to make the tabBar move up or down, for example a number
    //less than 580 would move the tab bar upwards, and larger than 580
    //moves the tab bar downwards
    self.tabBarController.view.frame = CGRectMake(0,0,320,580);
    [super viewDidLoad];
    
    [self configNavigationView];

    [self createTableView];

    [self configTableHeaderView];


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[WPContentService shared] contentPlanModel] selectedCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPPlanTableCell* cell = (WPPlanTableCell *)[tableView dequeueReusableCellWithIdentifier:@"WPPlanTableCell"];
    if (cell == nil) {
        cell = [[WPPlanTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"WPPlanTableCell"];
    }
    
//    //house
//    if (cell && indexPath.row == 0 && indexPath.section == 0) {
//        
//        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.0f);
//    }
    
    WPContentPlan *contentPlan = [[[WPContentService shared] contentPlanModel] selectedContentPlanAtIndex:indexPath.row];
    
    //set the background image for a cell
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"listrectanglebg.png"] stretchableImageWithLeftCapWidth:250.0 topCapHeight:0.0] ];
    
    //select the background image for a cell when its highlighted
//    cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"login_btn.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];

    //cell.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(cell.bounds)/2.0, 0, CGRectGetWidth(cell.bounds)/2.0);

    cell.iconImageView.image = [UIImage imageNamed:contentPlan.iconNameColor];
    cell.titleLabel.text = contentPlan.planName;
    cell.timeLabel.text = contentPlan.selectedTime;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPContentPlan *contentPlan = [[[WPContentService shared] contentPlanModel] selectedContentPlanAtIndex:indexPath.row];
    
    WPPlanTableCell* cell = (WPPlanTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.iconImageView.image = [UIImage imageNamed:contentPlan.iconNameColor];
    cell.titleLabel.textColor = [UIColor blackColor];
    cell.timeLabel.textColor = [UIColor lightGrayColor];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPContentPlan *contentPlan = [[[WPContentService shared] contentPlanModel] selectedContentPlanAtIndex:indexPath.row];
    
    WPPlanTableCell* cell = (WPPlanTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.iconImageView.image = [UIImage imageNamed:contentPlan.iconNameWhite];
    cell.titleLabel.textColor = [UIColor whiteColor];
    cell.timeLabel.textColor = [UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WPPlanTableCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
