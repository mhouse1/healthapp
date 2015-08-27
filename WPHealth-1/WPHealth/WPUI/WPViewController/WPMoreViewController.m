//
//  WPMoreViewController.m
//  WPHealth
//
//  Created by justone on 15-5-25.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPMoreViewController.h"
#import "WPLittleSaidViewController.h"
#import "WPAccountViewController.h"
#import "WPAboutViewController.h"

@interface WPMoreViewController () <UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation WPMoreViewController

#pragma mark - loadView

- (void)configTableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 15.0)];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView* tableBgView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., self.tableView.frame.size.width, self.tableView.frame.size.height)];
    tableBgView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = tableBgView;
    tableBgView = nil;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createTableView];
    [self configTableHeaderView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WPMoreTableCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"WPMoreTableCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blackColor];
        
        UIImageView* bottomLineSepView = [[UIImageView alloc] initWithFrame:CGRectZero];
        bottomLineSepView.backgroundColor = [UIColor clearColor];
        bottomLineSepView.image = [UIImage imageNamed:@"line.png"];
        [cell.contentView addSubview:bottomLineSepView];
        [bottomLineSepView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.left).offset(15.);
            make.bottom.equalTo(cell.contentView.bottom);
            make.height.equalTo(1);
            make.right.equalTo(cell.contentView.right);
        }];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"我的账号";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"点点说";
    } else {
        cell.textLabel.text = @"关于";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        WPAccountViewController *accountVC = [[WPAccountViewController alloc] init];
        accountVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:accountVC animated:YES];
    } else if (indexPath.row == 1) {
        WPLittleSaidViewController *littleSaidVC = [[WPLittleSaidViewController alloc] init];
        littleSaidVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:littleSaidVC animated:YES];
    } else {
        WPAboutViewController *aboutVC = [[WPAboutViewController alloc] init];
        aboutVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}


@end
