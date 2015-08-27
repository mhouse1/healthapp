//
//  WPPlanSettingViewController.m
//  WPHealth
//
//  Created by justone on 15/5/28.
//  Copyright (c) 2015年 justone. All rights reserved.
//
//@details viewcontroller that after user select an activity
//         allows users to select settings for that activity such as
//         days of week, duration, and alarm mode.

#import "WPPlanSettingViewController.h"
#import "ZHPickView.h"

@interface WPPlanSettingViewController ()<UITableViewDelegate,
UITableViewDataSource,
ZHPickViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) ZHPickView *pickview;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation WPPlanSettingViewController

#pragma mark - buttonAction

- (void)handleLastBtnEvent
{
    if (self.lastBtnBlock) {
        self.lastBtnBlock();
    }
}

- (void)handleFinishBtnEvent
{
    if (self.finishBtnBlock) {
        self.finishBtnBlock(self.contentPlan);
    }
}

- (void)handleSwitch:(UISwitch *)aSwitch
{
    self.contentPlan.notifyStatus = aSwitch.on == YES?@"1":@"0";
}

#pragma mark - loadView

- (void)configTableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0)];
    
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
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.top).offset(-40.0);//more negative means table is shifted up more
        make.bottom.equalTo(self.view.bottom).offset(-80.);//controls where the bottom of the table is
    }];
    
    UIView* tableBgView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., self.tableView.frame.size.width, self.tableView.frame.size.height)];
    tableBgView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = tableBgView;
    tableBgView = nil;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)createToolbar
{
    UIButton *lastBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [lastBtn setBackgroundImage:[UIImage imageNamed:@"last_step_btn.png"] forState:UIControlStateNormal];
    [lastBtn addTarget:self action:@selector(handleLastBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:lastBtn];
    [lastBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(118);
        make.height.equalTo(40);
        make.right.equalTo(self.view.centerX).offset(-10);
        make.bottom.equalTo(self.view.bottom).offset(-30);
    }];
    
    UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [finishBtn setBackgroundImage:[UIImage imageNamed:@"finish_btn.png"] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(handleFinishBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:finishBtn];
    [finishBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(116);
        make.height.equalTo(38);
        make.left.equalTo(self.view.centerX).offset(10);
        make.centerY.equalTo(lastBtn.centerY);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createTableView];
    [self configTableHeaderView];
    
    [self createToolbar];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:@"WPPlanTableCell"];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:82./255. green:184./255. blue:170./255. alpha:1.];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if (indexPath.row == 2) {
        cell.textLabel.text = @"打卡时间";
        cell.detailTextLabel.text = [self.contentPlan.selectedTime length] > 0?self.contentPlan.selectedTime:@"请选择打卡时间";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"运动时长";
        cell.detailTextLabel.text = [self.contentPlan.sportTime length] > 0?self.contentPlan.sportTime:@"请选择运动时长";
    } else if (indexPath.row == 0) {
        //row for days of week
        //create button for each day of the week
        UIButton *day1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [day1 setTitle:@"weekday" forState:UIControlStateNormal];

        [day1 setBackgroundImage:[UIImage imageNamed:@"Mon_Unselected.png"] forState:UIControlStateNormal];
        [day1 setFrame:CGRectMake(10, 5, 30,30)];
        //[selectTaskBtn setTag:indexPath.section];//not required buy may find useful if you need only section or row
        [cell addSubview:day1];

        
        //tuesday
        UIButton *day2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [day2 setTitle:@"weekday" forState:UIControlStateNormal];
        
        [day2 setBackgroundImage:[UIImage imageNamed:@"Tue_Unselected.png"] forState:UIControlStateNormal];
        [day2 setFrame:CGRectMake(55, 5, 30,30)];
        //[selectTaskBtn setTag:indexPath.section];//not required buy may find useful if you need only section or row
        [cell addSubview:day2];

        //wednesday
        UIButton *day3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [day3 setTitle:@"weekday" forState:UIControlStateNormal];
        
        [day3 setBackgroundImage:[UIImage imageNamed:@"Wed_Unselected.png"] forState:UIControlStateNormal];
        [day3 setFrame:CGRectMake(100, 5, 30,30)];
        //[selectTaskBtn setTag:indexPath.section];//not required buy may find useful if you need only section or row
        [cell addSubview:day3];

        //thursday
        UIButton *day4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [day4 setTitle:@"weekday" forState:UIControlStateNormal];
        
        [day4 setBackgroundImage:[UIImage imageNamed:@"Thu_Unselected.png"] forState:UIControlStateNormal];
        [day4 setFrame:CGRectMake(145, 5, 30,30)];
        //[selectTaskBtn setTag:indexPath.section];//not required buy may find useful if you need only section or row
        [cell addSubview:day4];

        //friday
        UIButton *day5 = [UIButton buttonWithType:UIButtonTypeCustom];
        [day5 setTitle:@"weekday" forState:UIControlStateNormal];
        
        [day5 setBackgroundImage:[UIImage imageNamed:@"Fri_Unselected.png"] forState:UIControlStateNormal];
        [day5 setFrame:CGRectMake(190, 5, 30,30)];
        //[selectTaskBtn setTag:indexPath.section];//not required buy may find useful if you need only section or row
        [cell addSubview:day5];

        //saturday
        UIButton *day6 = [UIButton buttonWithType:UIButtonTypeCustom];
        [day6 setTitle:@"weekday" forState:UIControlStateNormal];
        
        [day6 setBackgroundImage:[UIImage imageNamed:@"Sat_Unselected.png"] forState:UIControlStateNormal];
        [day6 setFrame:CGRectMake(235, 5, 30,30)];
        //[selectTaskBtn setTag:indexPath.section];//not required buy may find useful if you need only section or row
        [cell addSubview:day6];

        //sunday
        UIButton *day7 = [UIButton buttonWithType:UIButtonTypeCustom];
        [day7 setTitle:@"weekday" forState:UIControlStateNormal];
        
        [day7 setBackgroundImage:[UIImage imageNamed:@"Sun_Unselected.png"] forState:UIControlStateNormal];
        [day7 setFrame:CGRectMake(280, 5, 30,30)];
        //[selectTaskBtn setTag:indexPath.section];//not required buy may find useful if you need only section or row
        [cell addSubview:day7];

//        cell.textLabel.text = @"星期计划";
//        cell.detailTextLabel.text = [self.contentPlan.dayOfWeek length] > 0?self.contentPlan.dayOfWeek:@"请选择星期计划";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"通知提醒";
        cell.detailTextLabel.text = nil;
        
        UISwitch* ignoreSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [ignoreSwitch addTarget:self action:@selector(handleSwitch:) forControlEvents:UIControlEventValueChanged];
        ignoreSwitch.onTintColor = [UIColor colorWithRed:234./255. green:30./255. blue:138./255. alpha:1.];
        ignoreSwitch.tag = indexPath.row;
        [cell.contentView addSubview:ignoreSwitch];
        [ignoreSwitch makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-14.);
            make.centerY.equalTo(cell.contentView);
        }];
        
        BOOL open = [self.contentPlan.notifyStatus boolValue];
        ignoreSwitch.on = open;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //set the background image for a cell
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"listrectanglebg.png"] stretchableImageWithLeftCapWidth:250.0 topCapHeight:0.0] ];
    
    //select the background image for a cell when its highlighted
    //    cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"login_btn.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    //cell.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(cell.bounds)/2.0, 0, CGRectGetWidth(cell.bounds)/2.0);
    
    //configure extra stuff for the cell such as icon
    //cell.iconImageView.image = [UIImage imageNamed:contentPlan.iconNameColor];
    //cell.titleLabel.text = contentPlan.planName;
    //cell.timeLabel.text = contentPlan.selectedTime;
    
    return cell;
}

#pragma mark - UITableViewDelegate,

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.;//controls the height of cells in the table
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedIndexPath = indexPath;
    [self.pickview remove];
    
    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:0];
    
    if (indexPath.row == 2) {
        NSMutableArray *hourArray = [NSMutableArray arrayWithCapacity:0];
        for (int index = 1; index <= 24; index++) {
            [hourArray addObject:[NSString stringWithFormat:@"%02d", index]];
        }
        [contentArray addObject:hourArray];
        
        [contentArray addObject:@[@":"]];
        
        NSMutableArray *minArray = [NSMutableArray arrayWithCapacity:0];
        for (int index = 1; index <= 60; index++) {
            [minArray addObject:[NSString stringWithFormat:@"%02d", index]];
        }
        [contentArray addObject:minArray];
    } else if (indexPath.row == 1) {

        NSMutableArray *minArray = [NSMutableArray arrayWithCapacity:0];
        for (int index = 1; index <= 60; index++) {
            [minArray addObject:[NSString stringWithFormat:@"%02d", index]];
        }
        [contentArray addObject:minArray];
        
        [contentArray addObject:@[@"分钟"]];
        
    } else if (indexPath.row == 0) {
        
        NSMutableArray *minArray = [NSMutableArray arrayWithCapacity:0];
        for (int index = 1; index <= 7; index++) {
            [minArray addObject:[NSString stringWithFormat:@"%d", index]];
        }
        [contentArray addObject:minArray];
        
        [contentArray addObject:@[@"天"]];
    }
    
    self.pickview = [[ZHPickView alloc] initPickviewWithArray:contentArray];
    [self.pickview setTitleLabelWithString:@"测试标题"];
    self.pickview.delegate=self;
    [self.pickview show];
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    UITableViewCell * cell=[self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    
    cell.detailTextLabel.text = resultString;
}

@end
