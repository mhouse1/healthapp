//
//  WPProvinceViewController.m
//  CYTest
//
//  Created by justone on 14/10/31.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPProvinceViewController.h"
#import "WPCityViewController.h"

@interface WPProvinceViewController ()<UITableViewDelegate,
UITableViewDataSource>

@end

@implementation WPProvinceViewController
{
    NSString *_selectedCity;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackItem];
 
    self.title = @"省/区";
    
    NSString *waitReplaceCity = [[WPGlobalConfig shared] waitReplacedCity];
    if ([waitReplaceCity length] > 0) {
        _selectedCity = waitReplaceCity;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZRPTreeNode *tmpTreeNode = [[self.childrenTreeNode children] objectAtIndex:indexPath.row];
    if ([tmpTreeNode childrenCount] > 0) {
        WPCityViewController *cityVC = [[WPCityViewController alloc] init];
        cityVC.childrenTreeNode = tmpTreeNode;
        
        [self.navigationController pushViewController:cityVC animated:YES];
    } else {
        NSString *city = [NSString stringWithFormat:@"%@ %@", self.childrenTreeNode.title, tmpTreeNode.title];
        [[WPGlobalConfig shared] setWaitReplacedCity:city];
        
        _selectedCity = city;
        
        [self.provinceTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.25];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.childrenTreeNode childrenCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identified = @"gameTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identified];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:identified];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ZRPTreeNode *tmpTreeNode = [[self.childrenTreeNode children] objectAtIndex:indexPath.row];
    cell.textLabel.text = tmpTreeNode.title;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([tmpTreeNode childrenCount] > 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        NSString *city = [NSString stringWithFormat:@"%@ %@", self.childrenTreeNode.title, tmpTreeNode.title];
        if ([_selectedCity isEqualToString:city]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

@end
