//
//  ViewController.m
//  XYPieChart
//
//  Copyright (c) 2015 Michael House. All rights reserved.
//
//  pie chart view controller and table
#import <QuartzCore/QuartzCore.h>

#import "ViewController.h"

#define pieSliceColor1 [UIColor colorWithRed:98/255.0 green:197/255.0 blue:186/255.0 alpha:1]
#define pieSliceColor2 [UIColor colorWithRed:94/255.0 green:140/255.0 blue:193/255.0 alpha:1]
#define pieSliceColor3 [UIColor colorWithRed:98/255.0 green:190/255.0 blue:108/255.0 alpha:1]
#define pieSliceColor4 [UIColor colorWithRed:232/255.0 green:108/255.0 blue:96/255.0 alpha:1]
#define pieSliceColor5 [UIColor colorWithRed:250/255.0 green:170/255.0 blue:67/255.0 alpha:1]
#define pieSliceColor6 [UIColor colorWithRed:62/255.0 green:77/255.0 blue:104/255.0 alpha:1]
@implementation ViewController


@synthesize pieChartRight = _pieChart;
@synthesize pieChartLeft = _pieChartCopy;
@synthesize percentageLabel = _percentageLabel;
@synthesize selectedSliceLabel = _selectedSlice;
@synthesize numOfSlices = _numOfSlices;
@synthesize indexOfSlices = _indexOfSlices;
@synthesize downArrow = _downArrow;
@synthesize slices = _slices;
@synthesize sliceColors = _sliceColors;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//[regions count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    //Region *region = [regions objectAtIndex:section];
    return 5;//[region.timeZoneWrappers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    //Region *region = [regions objectAtIndex:section];
    return @"Items              Health Coins         %";//[region name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:@"WPPlanTableCell"];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:82./255. green:184./255. blue:170./255. alpha:1.];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if (indexPath.row == 0) {
        cell.backgroundColor = pieSliceColor1;
        UILabel *l1=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100,30)];
        
        UILabel *l2=[[UILabel alloc]initWithFrame:CGRectMake(165, 5, 100,30)];
        UILabel *l3=[[UILabel alloc]initWithFrame:CGRectMake(265, 5, 100,30)];
        l1.text = @"Exercise";
        l2.text = @"85";
        l3.text = @"32%";
        l1.textColor = [UIColor whiteColor];
        l2.textColor = [UIColor whiteColor];
        l3.textColor = [UIColor whiteColor];

        [cell.contentView addSubview:l1];
        [cell.contentView addSubview:l2];
        [cell.contentView addSubview:l3];
    } else if (indexPath.row == 1) {
        //set the background image for a cell
        cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"CoinBg.png"] stretchableImageWithLeftCapWidth:250.0 topCapHeight:0.0] ];
        UILabel *l1=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100,30)];
        
        UILabel *l2=[[UILabel alloc]initWithFrame:CGRectMake(165, 5, 100,30)];
        UILabel *l3=[[UILabel alloc]initWithFrame:CGRectMake(265, 5, 100,30)];
        l1.text = @"Running";
        l2.text = @"25";
        l3.text = @"9%";
        l1.textColor = [UIColor whiteColor];
        l2.textColor = [UIColor whiteColor];
        l3.textColor = [UIColor whiteColor];
        
        [cell.contentView addSubview:l1];
        [cell.contentView addSubview:l2];
        [cell.contentView addSubview:l3];
    } else if (indexPath.row == 2) {
        //set the background image for a cell
        cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"CoinBg.png"] stretchableImageWithLeftCapWidth:250.0 topCapHeight:0.0] ];
        
        UILabel *l1=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100,30)];
        
        UILabel *l2=[[UILabel alloc]initWithFrame:CGRectMake(165, 5, 100,30)];
        UILabel *l3=[[UILabel alloc]initWithFrame:CGRectMake(265, 5, 100,30)];
        l1.text = @"Plank";
        l2.text = @"28";
        l3.text = @"11%";
        l1.textColor = [UIColor whiteColor];
        l2.textColor = [UIColor whiteColor];
        l3.textColor = [UIColor whiteColor];

        [cell.contentView addSubview:l1];
        [cell.contentView addSubview:l2];
        [cell.contentView addSubview:l3];
        
    } else if (indexPath.row == 3) {
        //set the background image for a cell
        cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"CoinBg.png"] stretchableImageWithLeftCapWidth:250.0 topCapHeight:0.0] ];
        UILabel *l1=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100,30)];
        
        UILabel *l2=[[UILabel alloc]initWithFrame:CGRectMake(165, 5, 100,30)];
        UILabel *l3=[[UILabel alloc]initWithFrame:CGRectMake(265, 5, 100,30)];
        l1.text = @"Jump Rope";
        l2.text = @"14";
        l3.text = @"5%";
        l1.textColor = [UIColor whiteColor];
        l2.textColor = [UIColor whiteColor];
        l3.textColor = [UIColor whiteColor];

        [cell.contentView addSubview:l1];
        [cell.contentView addSubview:l2];
        [cell.contentView addSubview:l3];
    } else if (indexPath.row == 4) {
        //set the background image for a cell
        cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"CoinBg.png"] stretchableImageWithLeftCapWidth:250.0 topCapHeight:0.0] ];
        UILabel *l1=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100,30)];
        
        UILabel *l2=[[UILabel alloc]initWithFrame:CGRectMake(165, 5, 100,30)];
        UILabel *l3=[[UILabel alloc]initWithFrame:CGRectMake(265, 5, 100,30)];
        l1.text = @"helping xia";
        l2.text = @"112";
        l3.text = @"42%";
        l1.textColor = [UIColor whiteColor];
        l2.textColor = [UIColor whiteColor];
        l3.textColor = [UIColor whiteColor];

        [cell.contentView addSubview:l1];
        [cell.contentView addSubview:l2];
        [cell.contentView addSubview:l3];
        
    }
    
   
    
    //select the background image for a cell when its highlighted
    //    cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"login_btn.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    //cell.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(cell.bounds)/2.0, 0, CGRectGetWidth(cell.bounds)/2.0);
    
    //configure extra stuff for the cell such as icon
    //cell.iconImageView.image = [UIImage imageNamed:contentPlan.iconNameColor];
    //cell.titleLabel.text = contentPlan.planName;
    //cell.timeLabel.text = contentPlan.selectedTime;
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        self.slices = [NSMutableArray arrayWithCapacity:10];
    
//    for(int i = 0; i < 5; i ++)
//    {
//        NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
//        [_slices addObject:one];
//    }
    
    //initial percentage of points
    for(int i = 0; i < 6; i ++)
    {
        if (i == 0){
            NSNumber *one = [NSNumber numberWithInt:85];
            [_slices addObject:one];
        } else if (i == 1) {
            NSNumber *one = [NSNumber numberWithInt:25];
            [_slices addObject:one];
        }else if (i == 2) {
            NSNumber *one = [NSNumber numberWithInt:28];
            [_slices addObject:one];
        }else if (i == 3) {
            NSNumber *one = [NSNumber numberWithInt:14];
            [_slices addObject:one];
        } else if (i == 4){
            NSNumber *one = [NSNumber numberWithInt:112];
            [_slices addObject:one];
            
        }else if (i == 5){
            NSNumber *one = [NSNumber numberWithInt:40];
            [_slices addObject:one];
            
        }else{
            NSNumber *one = [NSNumber numberWithInt:40];
            [_slices addObject:one];
            
        }


    }
    
    [self.pieChartLeft setDelegate:self];
    [self.pieChartLeft setDataSource:self];
    [self.pieChartLeft setStartPieAngle:M_PI_2];
    [self.pieChartLeft setAnimationSpeed:2.0];
    //[self.pieChartLeft setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];
    //[self.pieChartLeft setLabelRadius:115];//sets how far away the label is from the pie slices
    //[self.pieChartLeft setShowPercentage:NO];//show percentage vs show value
    [self.pieChartLeft setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    //[self.pieChartLeft setPieCenter:CGPointMake(80, 80)];
    [self.pieChartLeft setUserInteractionEnabled:YES];
    [self.pieChartLeft setLabelShadowColor:[UIColor blackColor]];

    [self.pieChartRight setDelegate:self];
    [self.pieChartRight setDataSource:self];
    [self.pieChartRight setPieCenter:CGPointMake(240, 240)];
    [self.pieChartRight setShowPercentage:NO];
    [self.pieChartRight setUserInteractionEnabled:YES];
    [self.pieChartRight setLabelColor:[UIColor blackColor]];

    //[self.percentageLabel.layer setCornerRadius:77];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       pieSliceColor1,
                       pieSliceColor2,
                       pieSliceColor3,
                       pieSliceColor4,
                       pieSliceColor5,
                       pieSliceColor6,
                       nil];
    
    //rotate up arrow
    self.downArrow.transform = CGAffineTransformMakeRotation(M_PI);
    
}

- (void)viewDidUnload
{
    [self setPieChartLeft:nil];
    [self setPieChartRight:nil];
    [self setPercentageLabel:nil];
    [self setSelectedSliceLabel:nil];
    [self setIndexOfSlices:nil];
    [self setNumOfSlices:nil];
    [self setDownArrow:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"CoinBg.png"]]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChartLeft reloadData];
    [self.pieChartRight reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)AllMonthWeekTouched:(id)sender
{
    
        UIButton *button = (UIButton *) sender;
        //button.selected = !button.selected;
    NSLog(@"button touched: %ld",button.tag);
    NSLog(@"Button pressed: %@", [sender currentTitle]);
    [button setSelected:YES];

    if (button.tag == 1){
        UIButton *button1 = (UIButton *)[button.superview viewWithTag:2];
        [button1 setSelected:NO];
        UIButton *button2 = (UIButton *)[button.superview viewWithTag:3];
        [button2 setSelected:NO];
        [button setImage:[UIImage imageNamed:@"healthcoinsAll_Selected.png"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"healthcoinsAll_UnSelected.png"] forState:UIControlStateNormal];

    } else if (button.tag == 2) {
        UIButton *button1 = (UIButton *)[button.superview viewWithTag:1];
        [button1 setSelected:NO];
        UIButton *button2 = (UIButton *)[button.superview viewWithTag:3];
        [button2 setSelected:NO];
        [button1 setImage:[UIImage imageNamed:@"healthcoinsAll_UnSelected.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"healthcoinsMonth_Selected.png"] forState:UIControlStateSelected];
    } else if (button.tag == 3) {
        UIButton *button1 = (UIButton *)[button.superview viewWithTag:1];
        [button1 setSelected:NO];
        UIButton *button2 = (UIButton *)[button.superview viewWithTag:2];
        [button2 setSelected:NO];
        [button setImage:[UIImage imageNamed:@"healthcoinsWeek_Selected.png"] forState:UIControlStateSelected];
    }
    
    // Set the current button as the only selected one
    

}


- (IBAction)SliceNumChanged:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger num = self.numOfSlices.text.intValue;
    if(btn.tag == 100 && num > -10)
        num = num - ((num == 1)?2:1);
    if(btn.tag == 101 && num < 10)
        num = num + ((num == -1)?2:1);
    
    self.numOfSlices.text = [NSString stringWithFormat:@"%d",num];
}

- (IBAction)clearSlices {
    [_slices removeAllObjects];
    [self.pieChartLeft reloadData];
    [self.pieChartRight reloadData];
}

- (IBAction)addSliceBtnClicked:(id)sender 
{
    NSInteger num = [self.numOfSlices.text intValue];
    if (num > 0) {
        for (int n=0; n < abs(num); n++) 
        {
            NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
            NSInteger index = 0;
            if(self.slices.count > 0)
            {
                switch (self.indexOfSlices.selectedSegmentIndex) {
                    case 1:
                        index = rand()%self.slices.count;
                        break;
                    case 2:
                        index = self.slices.count - 1;
                        break;
                }
            }
            [_slices insertObject:one atIndex:index];
        }
    }
    else if (num < 0)
    {
        if(self.slices.count <= 0) return;
        for (int n=0; n < abs(num); n++) 
        {
            NSInteger index = 0;
            if(self.slices.count > 0)
            {
                switch (self.indexOfSlices.selectedSegmentIndex) {
                    case 1:
                        index = rand()%self.slices.count;
                        break;
                    case 2:
                        index = self.slices.count - 1;
                        break;
                }
                [_slices removeObjectAtIndex:index];
            }
        }
    }
    [self.pieChartLeft reloadData];
    [self.pieChartRight reloadData];
}

- (IBAction)updateSlices
{
    for(int i = 0; i < _slices.count; i ++)
    {
        if (i == 0){
          [_slices replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:85]];
        } else if (i == 1) {
            [_slices replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:25]];
        }else if (i == 2) {
            [_slices replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:28]];
        }else if (i == 3) {
            [_slices replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:14]];
        } else {
            [_slices replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:112]];

        }
    }
    [self.pieChartLeft reloadData];
    [self.pieChartRight reloadData];
}

- (IBAction)showSlicePercentage:(id)sender {
    UISwitch *perSwitch = (UISwitch *)sender;
    [self.pieChartRight setShowPercentage:perSwitch.isOn];
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    
    if(pieChart == self.pieChartRight) return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %ld",index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %ld",index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %ld",index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %ld",index);
    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
    
}

@end
