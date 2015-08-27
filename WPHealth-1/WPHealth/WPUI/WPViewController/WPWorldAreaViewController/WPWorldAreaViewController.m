//
//  WPWorldAreaViewController.m
//  CYTest
//
//  Created by justone on 14/10/31.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPWorldAreaViewController.h"
#import "WPProvinceViewController.h"

@interface WPWorldAreaViewController ()<UITableViewDelegate,
UITableViewDataSource>

@end

@implementation WPWorldAreaViewController
{
    NSString *_selectedCity;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackItem];
    self.title = @"国家";
    
    NSString *waitReplaceCity = [[WPGlobalConfig shared] waitReplacedCity];;
    if ([waitReplaceCity length] > 0) {
        _selectedCity = waitReplaceCity;
    }
    
    [[WPGlobalConfig shared] setNeedReplaceCity:@"1"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZRPTreeNode *tmpTreeNode = [[self.rootTreeNode children] objectAtIndex:indexPath.row];
    if ([tmpTreeNode childrenCount] > 0) {        
        WPProvinceViewController *provinceVC = [[WPProvinceViewController alloc] init];
        provinceVC.childrenTreeNode = tmpTreeNode;
        
        [self.navigationController pushViewController:provinceVC animated:YES];
    } else {
        NSString *city = [NSString stringWithFormat:@"%@", tmpTreeNode.title];
        
        [[WPGlobalConfig shared] setWaitReplacedCity:city];
        
        _selectedCity = city;
        
        [self.worldTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.25];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rootTreeNode childrenCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identified = @"gameTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identified];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:identified];
    }
    
    ZRPTreeNode *tmpTreeNode = [[self.rootTreeNode children] objectAtIndex:indexPath.row];
    cell.textLabel.text = tmpTreeNode.title;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([tmpTreeNode childrenCount] > 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        NSString *city = [NSString stringWithFormat:@"%@", tmpTreeNode.title];
        if ([_selectedCity isEqualToString:city]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

@end
