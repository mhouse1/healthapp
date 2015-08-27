//
//  WPCityViewController.m
//  CYTest
//
//  Created by justone on 14/10/31.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPCityViewController.h"

@interface WPCityViewController ()<UITableViewDelegate,
UITableViewDataSource>

@end

@implementation WPCityViewController
{
    NSString *_selectedCity;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackItem];
    
    self.title = @"城市/区";
    
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
    NSString *city = [NSString stringWithFormat:@"%@ %@", self.childrenTreeNode.title, tmpTreeNode.title];
    
    [[WPGlobalConfig shared] setWaitReplacedCity:city];
    
    _selectedCity = city;
    
    [self.cityTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.25];
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
